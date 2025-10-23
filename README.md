# 🧩 TeamSpeak 3 Server – MariaDB-ready (Unraid)

[➡️ Releases & Changelog](https://github.com/Blackbandit1804/ts3-mariadb/releases)


![Docker Pulls](https://img.shields.io/docker/pulls/blackbandit1804/teamspeak-mariadb?style=for-the-badge&logo=docker)
![Image Size](https://img.shields.io/docker/image-size/blackbandit1804/teamspeak-mariadb/latest?style=for-the-badge)
![GitHub Release](https://img.shields.io/github/v/release/Blackbandit1804/ts3-mariadb?style=for-the-badge&logo=github)
![GitHub last commit](https://img.shields.io/github/last-commit/Blackbandit1804/ts3-mariadb?style=for-the-badge&logo=github)
![Platform](https://img.shields.io/badge/platform-Unraid-orange?style=for-the-badge&logo=unraid)
![Maintainer](https://img.shields.io/badge/maintainer-Blackbandit1804-blue?style=for-the-badge&logo=github)

**TeamSpeak 3 Server (Basis: [ich777/docker-teamspeak](https://github.com/ich777/docker-teamspeak))**  
Leichtgewichtiges, Unraid-freundliches Image mit aktivierter **MariaDB**-Anbindung (statt SQLite).  
Getestet auf **Unraid 7.1.4**.

---

## 🇩🇪 Deutsch

### 💡 Highlights
- 🧩 **MariaDB statt SQLite** – robust & skalierbar  
- ⚙️ **Unraid-ready** – korrekte UID/GID/UMASK, persistente Daten  
- 🚫 **Kein sudo** – Start via `gosu` (non-root)  
- 🗂️ **Auto-Setup** – erzeugt bei Bedarf `ts3server.ini` & `ts3db_mariadb.ini`

### 🏷️ Supported tags
- `latest` – aktuelles Build
- `3.13.7` – TeamSpeak Server 3.13.7
- `YYYY.MM.DD` – Build-Datum (z. B. `2025.10.22`)
- `vX.Y.Z` / `X.Y.Z` – Release tags (z. B. `v1.0.1` und `1.0.1`)

### 🖥️ Architectures
- ✅ linux/amd64

### 🚀 Schnellstart (Docker CLI)
```bash
docker run -d --name TeamSpeak3-MariaDB \
  --restart unless-stopped \
  -p 9987:9987/udp -p 10011:10011 -p 30033:30033 \
  -e TS3SERVER_LICENSE=accept \
  -e EXTRA_START_PARAMS="inifile=/teamspeak/ts3server.ini" \
  -e UID=99 -e GID=100 -e UMASK=000 -e DATA_PERM=770 \
  -v /mnt/cache/appdata/teamspeak3:/teamspeak \
  blackbandit1804/teamspeak-mariadb:latest
```

> Beim ersten Start wird `ts3server.ini` automatisch erzeugt.  
> DB-Parameter liegen in `/teamspeak/ts3db_mariadb.ini`.

### 🧩 Installation auf Unraid (DockerMan)
```bash
mkdir -p /boot/config/plugins/dockerMan/templates-user
curl -fsSL "https://raw.githubusercontent.com/Blackbandit1804/docker-templates/main/TeamSpeak3-MariaDB.xml"   -o /boot/config/plugins/dockerMan/templates-user/TeamSpeak3-MariaDB.xml
```
Danach in der WebUI: **Docker → Container hinzufügen → Vorlage „TeamSpeak3-MariaDB“** auswählen.

### ⚙️ Konfiguration

**Volumes**
- `/teamspeak` → persistente Daten (INI, Logs, Dateien)  
  *Empfehlung:* `/mnt/cache/appdata/teamspeak3:/teamspeak`

### 🌐 Ports
| Dienst             | Port/Proto |
|--------------------|------------|
| Voice              | 9987/udp   |
| Server Query       | 10011/tcp  |
| File Transfer      | 30033/tcp  |
| TSDNS *(optional)* | 41144/tcp  |

**Wichtige Variablen**
- `TS3SERVER_LICENSE=accept` *(Pflicht)*  
- `EXTRA_START_PARAMS=inifile=/teamspeak/ts3server.ini`  
- `UID=99` · `GID=100` · `UMASK=000` · `DATA_PERM=770`

**🗄️ MariaDB-Beispiel (`/teamspeak/ts3db_mariadb.ini`)**
```ini
[config]
host=your-mariadb-host
port=3306
username=teamspeak
password=STRONG_PASSWORD
database=teamspeak
socket=
```

### 🧯 Troubleshooting (kurz)
- **Lizenzfehler:** `TS3SERVER_LICENSE=accept` setzen  
- **DB-Verbindung:** Host/Port/Netz prüfen (gleiches Docker-Netz)  
- **Port belegt:** Host-Ports anpassen  
- **Rechte:** `/teamspeak` gehört `99:100`, `DATA_PERM=770`

Logs:
```bash
docker logs -f TeamSpeak3-MariaDB
```

---

## 🇬🇧 English

### 💡 Highlights
- 🧩 **MariaDB instead of SQLite** — stable & scalable  
- ⚙️ **Unraid-ready** — proper UID/GID/UMASK, persistent data  
- 🚫 **No sudo** — runs via `gosu` (non-root)  
- 🗂️ **Auto-setup** — creates `ts3server.ini` & `ts3db_mariadb.ini` if needed

### 🏷️ Supported tags
- `latest` – current Build
- `3.13.7` – TeamSpeak Server 3.13.7
- `YYYY.MM.DD` – Build date (e.g. `2025.10.22`)
- `vX.Y.Z` / `X.Y.Z` – Release tags (e.g. `v1.0.1` and `1.0.1`)

### 🖥️ Architectures
- ✅ linux/amd64

### 🚀 Quick Start (Docker CLI)
```bash
docker run -d --name TeamSpeak3-MariaDB \
  --restart unless-stopped \
  -p 9987:9987/udp -p 10011:10011 -p 30033:30033 \
  -e TS3SERVER_LICENSE=accept \
  -e EXTRA_START_PARAMS="inifile=/teamspeak/ts3server.ini" \
  -e UID=99 -e GID=100 -e UMASK=000 -e DATA_PERM=770 \
  -v /mnt/cache/appdata/teamspeak3:/teamspeak \
  blackbandit1804/teamspeak-mariadb:latest
```

> On first launch, `ts3server.ini` is generated automatically.  
> DB settings are written to `/teamspeak/ts3db_mariadb.ini`.

### 🧩 Install on Unraid (DockerMan)
```bash
mkdir -p /boot/config/plugins/dockerMan/templates-user
curl -fsSL "https://raw.githubusercontent.com/Blackbandit1804/docker-templates/main/TeamSpeak3-MariaDB.xml"   -o /boot/config/plugins/dockerMan/templates-user/TeamSpeak3-MariaDB.xml
```
Then in the web UI: **Docker → Add Container → Template “TeamSpeak3-MariaDB”**.

### ⚙️ Configuration

**Volumes**
- `/teamspeak` → persistent data (INI, logs, files)  
  *Recommended:* `/mnt/cache/appdata/teamspeak3:/teamspeak`

### 🌐 Ports
| Service            | Port/Proto |
|--------------------|------------|
| Voice              | 9987/udp   |
| Server Query       | 10011/tcp  |
| File Transfer      | 30033/tcp  |
| TSDNS *(optional)* | 41144/tcp  |

**Key Variables**
- `TS3SERVER_LICENSE=accept` *(required)*  
- `EXTRA_START_PARAMS=inifile=/teamspeak/ts3server.ini`  
- `UID=99` · `GID=100` · `UMASK=000` · `DATA_PERM=770`

**🗄️ MariaDB example (`/teamspeak/ts3db_mariadb.ini`)**
```ini
[config]
host=your-mariadb-host
port=3306
username=teamspeak
password=STRONG_PASSWORD
database=teamspeak
socket=
```

### 🧯 Troubleshooting (short)
- **License error:** set `TS3SERVER_LICENSE=accept`  
- **DB connection:** verify host/port/network (same Docker network)  
- **Port conflict:** adjust host ports  
- **Permissions:** `/teamspeak` owned by `99:100`, `DATA_PERM=770`

---

## 🔗 Links
- **Docker Hub:** <https://hub.docker.com/r/blackbandit1804/teamspeak-mariadb>  
- **Unraid Template:** <https://github.com/Blackbandit1804/docker-templates>  
- **TeamSpeak:** <https://www.teamspeak.com/>

---

### 🧱 Hinweis zur Basis
Dieses Projekt basiert auf [**„TeamSpeak 3 Server (Basis: ich777)”**](https://github.com/ich777/docker-teamspeak) und erweitert es um eine saubere MariaDB-Integration, Unraid-freundliche Defaults und `gosu`-basierte Startscripte.
