FROM ich777/debian-baseimage

LABEL org.opencontainers.image.title="TeamSpeak 3 Server (MariaDB, Unraid)"
LABEL org.opencontainers.image.description="TeamSpeak 3 Server mit MariaDB-Support, getestet auf Unraid 7.1.4."
LABEL org.opencontainers.image.vendor="blackbandit1804"
LABEL org.opencontainers.image.source="https://github.com/Blackbandit1804/docker-teamspeak"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/blackbandit1804/teamspeak-mariadb"
LABEL org.opencontainers.image.licenses="MIT"

# Standard-ENV wie bei ich777 – plus meine Ergänzungen
ENV DATA_DIR="/teamspeak" \
    TS3SERVER_LICENSE="" \
    ENABLE_TSDNS="" \
    EXTRA_START_PARAMS="" \
    UMASK=000 \
    UID=99 \
    GID=100 \
    DATA_PERM=770 \
    USER="teamspeak" \
    # MariaDB-ENV (nur Defaults; real setzt du sie später im Template/UI)
    TS3_DB_HOST="" \
    TS3_DB_PORT="3306" \
    TS3_DB_NAME="ts3" \
    TS3_DB_USER="ts3" \
    TS3_DB_PASSWORD="" \
    TS3_DB_KEEPALIVE="60" \
    # Wichtig: Suchpfad für DB-Plugin & libmariadb
    LD_LIBRARY_PATH="/serverfiles:/serverfiles/redist"

# Tools, curl, bzip2, etc.
RUN apt-get update && \
    apt-get -y install --no-install-recommends curl jq bzip2 ca-certificates gosu && \
    rm -rf /var/lib/apt/lists/*

# Benutzer & Verzeichnis wie bei ich777
RUN mkdir -p "$DATA_DIR" && \
    useradd -d "$DATA_DIR" -s /bin/bash "$USER" && \
    chown -R "$USER":"$USER" "$DATA_DIR" && \
    ulimit -n 2048

# Unsere Templates & Entrypoint reinlegen
ADD defaults/ /opt/defaults/
ADD scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts && chmod -R 755 /opt/defaults

EXPOSE 10011
EXPOSE 30033
EXPOSE 9987/udp

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
