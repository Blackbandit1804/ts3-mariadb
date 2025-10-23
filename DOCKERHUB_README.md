# 🧩 TeamSpeak 3 Server – MariaDB-ready (Unraid)

![Docker Pulls](https://img.shields.io/docker/pulls/blackbandit1804/teamspeak-mariadb?style=for-the-badge&logo=docker)
![Image Size](https://img.shields.io/docker/image-size/blackbandit1804/teamspeak-mariadb/latest?style=for-the-badge)
![GitHub Release](https://img.shields.io/github/v/release/Blackbandit1804/ts3-mariadb?style=for-the-badge&logo=github)
![Status](https://img.shields.io/badge/status-stable-success?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Unraid-orange?style=for-the-badge&logo=unraid)
![Maintainer](https://img.shields.io/badge/maintainer-Blackbandit1804-blue?style=for-the-badge&logo=github)

---

### 🇩🇪 Deutsch

**TeamSpeak 3 Server (Basis: [ich777/docker-teamspeak](https://github.com/ich777/docker-teamspeak))**
Leichtgewichtiges, Unraid-freundliches Image mit aktivierter **MariaDB**-Anbindung
(statt SQLite). Getestet auf **Unraid 7.1.4**.

---

### 🚀 Schnellstart

```bash
docker run -d --name TeamSpeak3-MariaDB   --restart unless-stopped   -p 9987:9987/udp -p 10011:10011 -p 30033:30033   -e TS3SERVER_LICENSE=accept   -e EXTRA_START_PARAMS="inifile=/teamspeak/ts3server.ini"   -e UID=99 -e GID=100 -e UMASK=000 -e DATA_PERM=770   -v /mnt/cache/appdata/teamspeak3:/teamspeak   blackbandit1804/teamspeak-mariadb:latest
```

Beim ersten Start werden `ts3server.ini` und `ts3db_mariadb.ini` automatisch erzeugt.

---

### ⚙️ Konfiguration

| Variable | Beschreibung | Standard |
|-----------|---------------|-----------|
| `TS3SERVER_LICENSE` | Lizenzzustimmung (`accept` oder `view`) | `accept` |
| `EXTRA_START_PARAMS` | Startparameter für ts3server | `inifile=/teamspeak/ts3server.ini` |
| `UID` / `GID` | Benutzerrechte in Unraid | `99` / `100` |
| `UMASK` | Datei-Berechtigungen | `000` |
| `DATA_PERM` | chmod auf `/teamspeak` | `770` |

**Ports:**
- UDP 9987 (Voice)
- TCP 10011 (Server Query)
- TCP 30033 (File Transfer)
- *(optional)* TCP 41144 (TSDNS)

**Pfad:**
`/teamspeak` → persistente Daten (INI, Logs, Dateien)

---

### 🧰 MariaDB Beispiel (`/teamspeak/ts3db_mariadb.ini`)

```ini
[config]
host=your-mariadb-host
port=3306
username=teamspeak
password=STRONG_PASSWORD
database=teamspeak
socket=
```

---

### 🧯 Troubleshooting (kurz)

| Problem | Lösung |
|----------|---------|
| Lizenzfehler | `TS3SERVER_LICENSE=accept` setzen |
| DB-Verbindung schlägt fehl | Host/Port/Netz prüfen (gleiches Docker-Netz) |
| Port belegt | Host-Ports anpassen |
| Rechteprobleme | `/teamspeak` gehört `99:100`, `DATA_PERM=770` |

Logs anzeigen:
```bash
docker logs -f TeamSpeak3-MariaDB
```

---

### 🇬🇧 English (Short Version)

**TeamSpeak 3 Server (Base: [ich777/docker-teamspeak](https://github.com/ich777/docker-teamspeak))**
Lightweight, Unraid-ready image with **MariaDB** support (instead of SQLite).
Tested on **Unraid 7.1.4**.

**Quick Start**
```bash
docker run -d --name TeamSpeak3-MariaDB   --restart unless-stopped   -p 9987:9987/udp -p 10011:10011 -p 30033:30033   -e TS3SERVER_LICENSE=accept   -v /mnt/cache/appdata/teamspeak3:/teamspeak   blackbandit1804/teamspeak-mariadb:latest
```

**Config:** same variables as above
**MariaDB config:** `/teamspeak/ts3db_mariadb.ini`

---

### 🔗 Links

- 🐳 **Docker Hub:** [blackbandit1804/teamspeak-mariadb](https://hub.docker.com/r/blackbandit1804/teamspeak-mariadb)
- 💾 **GitHub Source:** [Blackbandit1804/ts3-mariadb](https://github.com/Blackbandit1804/ts3-mariadb)
- 🔧 **Unraid Template:** [Blackbandit1804/docker-templates](https://github.com/Blackbandit1804/docker-templates)
- 🎧 **TeamSpeak:** [teamspeak.com](https://www.teamspeak.com)

---

🧱 **Hinweis zur Basis**
Dieses Projekt basiert auf [„TeamSpeak 3 Server (Basis: ich777)“](https://github.com/ich777/docker-teamspeak)
und erweitert es um eine saubere MariaDB-Integration, Unraid-freundliche Defaults
und gosu-basierte Startscripte.
