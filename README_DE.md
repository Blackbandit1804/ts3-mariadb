# 🧩 TeamSpeak 3 Server – MariaDB-ready (Unraid)

![Docker Pulls](https://img.shields.io/docker/pulls/blackbandit1804/teamspeak-mariadb?style=for-the-badge&logo=docker)
![Image Size](https://img.shields.io/docker/image-size/blackbandit1804/teamspeak-mariadb/latest?style=for-the-badge)
![GitHub Release](https://img.shields.io/github/v/release/Blackbandit1804/ts3-mariadb?style=for-the-badge&logo=github)
![Status](https://img.shields.io/badge/status-stable-success?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Unraid-orange?style=for-the-badge&logo=unraid)
![Maintainer](https://img.shields.io/badge/maintainer-Blackbandit1804-blue?style=for-the-badge&logo=github)

---

## Überblick

**TeamSpeak 3 Server (inspiriert von [ich777/docker-teamspeak](https://github.com/ich777/docker-teamspeak))**  
Eigenes, schlankes Image für Unraid mit aktivierter **MariaDB**‑Anbindung (statt SQLite).  
Getestet auf **Unraid 7.1.4**.

- Läuft ohne `sudo`, startet sauber über `gosu` als Nicht‑Root.  
- Benutzt feste UID/GID/UMASK wie Unraid es erwartet.  
- Erstellt bei Bedarf automatisch `ts3server.ini` und `ts3db_mariadb.ini`.  
- Speichert alles persistent unter `/teamspeak`.

---

## 🚀 Schnellstart

```bash
docker run -d --name TeamSpeak3-MariaDB   --restart unless-stopped   -p 9987:9987/udp   -p 10011:10011   -p 30033:30033   -e TS3SERVER_LICENSE=accept   -e EXTRA_START_PARAMS="inifile=/teamspeak/ts3server.ini"   -e UID=99   -e GID=100   -e UMASK=000   -e DATA_PERM=770   -v /mnt/cache/appdata/teamspeak3:/teamspeak   blackbandit1804/teamspeak-mariadb:latest
```

Beim ersten Start werden `ts3server.ini` und `ts3db_mariadb.ini` automatisch erzeugt, falls sie fehlen.

---

## ⚙️ Konfiguration (Umgebungsvariablen)

| Variable | Beschreibung | Standardwert |
|---|---|---|
| `TS3SERVER_LICENSE` | Lizenzzustimmung (`accept` oder `view`) | `accept` |
| `EXTRA_START_PARAMS` | Startparameter für `ts3server` | `inifile=/teamspeak/ts3server.ini` |
| `UID` / `GID` | Benutzerrechte in Unraid | `99` / `100` |
| `UMASK` | Datei‑Berechtigungen | `000` |
| `DATA_PERM` | `chmod` auf `/teamspeak` | `770` |
| `TS_VER` | TeamSpeak‑Version (wird geladen, wenn keine Daten vorhanden) | `3.13.7` |
| `TS_URL` | Download‑URL (automatisch generiert aus `TS_VER`) | auto |

💡 **Hinweis:** Ändere `TS_VER` oder `TS_URL`, um beim nächsten Start automatisch die angegebene Version neu zu laden.

---

## 🌐 Ports

| Dienst | Port/Proto |
|---|---|
| Voice | `9987/udp` |
| Server Query | `10011/tcp` |
| File Transfer | `30033/tcp` |
| TSDNS *(optional)* | `41144/tcp` |

---

## 📂 Daten

`/teamspeak` → persistente Daten (INI, Logs, Dateien)

Empfohlenes Volume‑Mapping:

```bash
-v /mnt/cache/appdata/teamspeak3:/teamspeak
```

---

## 🧰 MariaDB Beispiel

```ini
[config]
host=your-mariadb-host
port=3306
username=teamspeak
password=STRONG_PASSWORD
database=teamspeak
socket=
```

Der Container ergänzt außerdem **nicht‑destruktiv** die `ts3server.ini` (z. B. `dbplugin=ts3db_mariadb`, `dbsqlpath=/teamspeak/sql/`, `dbsqlcreatepath=create_mariadb/`, sowie Host/User/Pass/Keepalive).

---

## 🏷️ Tags

- `latest` – aktuelles Build  
- `vX.Y.Z` – Release‑Version (Git‑Tag)  
- `3.13.7` – TS‑Version, mit der getestet wurde  
- `YYYY.MM.DD` – Build‑Datum

Architektur: ✅ `linux/amd64`

---

## 🧯 Troubleshooting

| Problem | Lösung / Check |
|---|---|
| Lizenzfehler beim Start | `TS3SERVER_LICENSE=accept` setzen |
| DB‑Verbindung schlägt fehl | Host/IP prüfen, MariaDB erreichbar, gleiches Docker‑Netz? |
| Port schon belegt | Host‑Ports (`-p ...`) anpassen |
| Rechte kaputt | `UID=99`, `GID=100`, `DATA_PERM=770` setzen und neu starten |

Logs ansehen:
```bash
docker logs -f TeamSpeak3-MariaDB
```

---

## 🔗 Links

- Docker Hub: https://hub.docker.com/r/blackbandit1804/teamspeak-mariadb  
- GitHub Source: https://github.com/Blackbandit1804/ts3-mariadb  
- Unraid Template: https://github.com/Blackbandit1804/docker-templates  
- TeamSpeak: https://www.teamspeak.com

---

## 📎 Herkunft

Dieses Image ist **nicht** direkt aus `ich777/docker-teamspeak` gebaut, sondern ein eigenständiger Build.  
Wir haben uns am Stil (UID/GID/UMASK) orientiert und ergänzt um: MariaDB‑Integration, automatische INIs, `gosu`‑Start, `TS_VER`/`TS_URL`‑Logik.
