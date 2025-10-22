#!/usr/bin/env bash
set -euo pipefail

# ---- Variablen wie im ich777-Image ----
DATA_DIR="${DATA_DIR:-/teamspeak}"
USER="${USER:-teamspeak}"
UMASK="${UMASK:-000}"
UID="${UID:-99}"
GID="${GID:-100}"
DATA_PERM="${DATA_PERM:-770}"

# ---- MariaDB Variablen ----
TS3_DB_HOST="${TS3_DB_HOST:-}"
TS3_DB_PORT="${TS3_DB_PORT:-3306}"
TS3_DB_NAME="${TS3_DB_NAME:-ts3}"
TS3_DB_USER="${TS3_DB_USER:-ts3}"
TS3_DB_PASSWORD="${TS3_DB_PASSWORD:-}"
TS3_DB_KEEPALIVE="${TS3_DB_KEEPALIVE:-60}"

EXTRA_START_PARAMS="${EXTRA_START_PARAMS:-}"
TS3SERVER_LICENSE="${TS3SERVER_LICENSE:-}"

# ---- Nutzer/Gruppe anpassen ----
if id -u "$USER" >/dev/null 2>&1; then
  usermod -u "$UID" "$USER" || true
  groupmod -g "$GID" "$USER" || true
fi
chown -R "$UID:$GID" "$DATA_DIR" || true
chmod -R "$DATA_PERM" "$DATA_DIR" || true
umask "$UMASK"

echo "---Ensuring UID: $UID matches user---"
echo "---Ensuring GID: $GID matches user---"
echo "---Setting umask to $UMASK---"
echo "---Starting---"

# ---- Serverdateien (einmalig) laden, falls fehlen ----
if [ ! -f "$DATA_DIR/ts3server" ]; then
  echo "---Downloading TeamSpeak3 Server (3.13.7)---"
  TMPDIR="$(mktemp -d)"
  curl -fsSL -o "$TMPDIR/ts3.tar.bz2" \
    "https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2"
  tar -xjf "$TMPDIR/ts3.tar.bz2" -C "$TMPDIR"
  cp -a "$TMPDIR/teamspeak3-server_linux_amd64/." "$DATA_DIR/"
  rm -rf "$TMPDIR"
  chown -R "$UID:$GID" "$DATA_DIR"
fi

# ---- Default-INI nur anlegen, wenn nicht vorhanden ----
if [ ! -f "$DATA_DIR/ts3server.ini" ]; then
  echo "---No ts3server.ini found, creating from template---"
  cp /opt/defaults/ts3server.ini.tpl "$DATA_DIR/ts3server.ini"
fi

# ---- ts3db_mariadb.ini bei Bedarf erzeugen ----
if [ -n "$TS3_DB_HOST" ] && [ ! -f "$DATA_DIR/ts3db_mariadb.ini" ]; then
  echo "---No ts3db_mariadb.ini found, creating from template---"
  sed -e "s|{{DB_HOST}}|$TS3_DB_HOST|g" \
      -e "s|{{DB_PORT}}|$TS3_DB_PORT|g" \
      -e "s|{{DB_NAME}}|$TS3_DB_NAME|g" \
      -e "s|{{DB_USER}}|$TS3_DB_USER|g" \
      -e "s|{{DB_PASSWORD}}|$TS3_DB_PASSWORD|g" \
      /opt/defaults/ts3db_mariadb.ini.tpl > "$DATA_DIR/ts3db_mariadb.ini"
fi

# ---- MariaDB in ts3server.ini ergänzen (nicht überschreiben) ----
if [ -n "$TS3_DB_HOST" ]; then
  echo "---Injecting MariaDB defaults into ts3server.ini (non-destructive)---"
  # dbplugin -> MariaDB
  if grep -qi '^dbplugin=' "$DATA_DIR/ts3server.ini"; then
    sed -i 's/^dbplugin=.*/dbplugin=ts3db_mariadb/i' "$DATA_DIR/ts3server.ini"
  else
    echo "dbplugin=ts3db_mariadb" >> "$DATA_DIR/ts3server.ini"
  fi

  # korrekte SQL-Pfade: WIR nutzen /teamspeak (nicht /serverfiles)
  if grep -qi '^dbsqlpath=' "$DATA_DIR/ts3server.ini"; then
    sed -i 's|^dbsqlpath=.*|dbsqlpath=/teamspeak/sql/|i' "$DATA_DIR/ts3server.ini"
  else
    echo "dbsqlpath=/teamspeak/sql/" >> "$DATA_DIR/ts3server.ini"
  fi
  if grep -qi '^dbsqlcreatepath=' "$DATA_DIR/ts3server.ini"; then
    sed -i 's|^dbsqlcreatepath=.*|dbsqlcreatepath=create_mariadb/|i' "$DATA_DIR/ts3server.ini"
  else
    echo "dbsqlcreatepath=create_mariadb/" >> "$DATA_DIR/ts3server.ini"
  fi

  # optionale Komfort-Werte in ts3server.ini (werden vom Server erkannt)
  grep -qi '^dbhost=' "$DATA_DIR/ts3server.ini" || echo "dbhost=$TS3_DB_HOST" >> "$DATA_DIR/ts3server.ini"
  grep -qi '^dbport=' "$DATA_DIR/ts3server.ini" || echo "dbport=$TS3_DB_PORT" >> "$DATA_DIR/ts3server.ini"
  grep -qi '^dbname=' "$DATA_DIR/ts3server.ini" || echo "dbname=$TS3_DB_NAME" >> "$DATA_DIR/ts3server.ini"
  grep -qi '^dbuser=' "$DATA_DIR/ts3server.ini" || echo "dbuser=$TS3_DB_USER" >> "$DATA_DIR/ts3server.ini"
  grep -qi '^dbpassword=' "$DATA_DIR/ts3server.ini" || echo "dbpassword=$TS3_DB_PASSWORD" >> "$DATA_DIR/ts3server.ini"
  grep -qi '^dbclientkeepalive=' "$DATA_DIR/ts3server.ini" || echo "dbclientkeepalive=$TS3_DB_KEEPALIVE" >> "$DATA_DIR/ts3server.ini"
fi

# Rechte & Libpfade setzen
chown -R "$UID:$GID" "$DATA_DIR"

# immens wichtig für libts3db_mariadb.so + redist/libmariadb.so.2:
export LD_LIBRARY_PATH="$DATA_DIR:$DATA_DIR/redist:${LD_LIBRARY_PATH:-/serverfiles:/serverfiles/redist}"

# License-Info
[ "${TS3SERVER_LICENSE:-}" = "accept" ] && echo "---License accepted---"

# Start
cd "$DATA_DIR"
echo "---Starting TeamSpeak3---"
# gosu statt sudo (sudo ist nicht installiert)
exec gosu "$UID:$GID" ./ts3server ${EXTRA_START_PARAMS}
