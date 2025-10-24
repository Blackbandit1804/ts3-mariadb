# 🧩 TeamSpeak 3 Server – MariaDB-ready (Unraid)

![Docker Pulls](https://img.shields.io/docker/pulls/blackbandit1804/teamspeak-mariadb?style=for-the-badge&logo=docker)
![Image Size](https://img.shields.io/docker/image-size/blackbandit1804/teamspeak-mariadb/latest?style=for-the-badge)
![GitHub Release](https://img.shields.io/github/v/release/Blackbandit1804/ts3-mariadb?style=for-the-badge&logo=github)
![Status](https://img.shields.io/badge/status-stable-success?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Unraid-orange?style=for-the-badge&logo=unraid)
![Maintainer](https://img.shields.io/badge/maintainer-Blackbandit1804-blue?style=for-the-badge&logo=github)

---

## Overview

**TeamSpeak 3 Server (inspired by [ich777/docker-teamspeak](https://github.com/ich777/docker-teamspeak))**  
Standalone, lightweight Unraid image with **MariaDB** support (instead of SQLite).  
Tested on **Unraid 7.1.4**.

- Runs without `sudo`, starts via `gosu` as non‑root.  
- Stable UID/GID/UMASK handling compatible with Unraid.  
- Automatically creates `ts3server.ini` and `ts3db_mariadb.ini` if missing.  
- Stores all persistent data under `/teamspeak`.

---

## 🚀 Quick Start

```bash
docker run -d --name TeamSpeak3-MariaDB   --restart unless-stopped   -p 9987:9987/udp   -p 10011:10011   -p 30033:30033   -e TS3SERVER_LICENSE=accept   -e EXTRA_START_PARAMS="inifile=/teamspeak/ts3server.ini"   -e UID=99   -e GID=100   -e UMASK=000   -e DATA_PERM=770   -v /mnt/cache/appdata/teamspeak3:/teamspeak   blackbandit1804/teamspeak-mariadb:latest
```

On first start, `ts3server.ini` and `ts3db_mariadb.ini` are generated automatically if missing.

---

## ⚙️ Configuration (environment variables)

| Variable | Description | Default |
|---|---|---|
| `TS3SERVER_LICENSE` | License acceptance (`accept` or `view`) | `accept` |
| `EXTRA_START_PARAMS` | Extra parameters for `ts3server` | `inifile=/teamspeak/ts3server.ini` |
| `UID` / `GID` | File ownership IDs (Unraid style) | `99` / `100` |
| `UMASK` | File creation mask | `000` |
| `DATA_PERM` | `chmod` applied on `/teamspeak` | `770` |
| `TS_VER` | TeamSpeak version to fetch (if no data present) | `3.13.7` |
| `TS_URL` | Direct download URL (auto‑derived from `TS_VER`) | auto |

💡 **Tip:** Change `TS_VER` or `TS_URL` to automatically download that version on next start.

---

## 🌐 Ports

| Service | Port/Proto |
|---|---|
| Voice | `9987/udp` |
| Server Query | `10011/tcp` |
| File Transfer | `30033/tcp` |
| TSDNS *(optional)* | `41144/tcp` |

---

## 📂 Data

`/teamspeak` → persistent data (INIs, logs, uploads)

Recommended volume mapping:

```bash
-v /mnt/cache/appdata/teamspeak3:/teamspeak
```

---

## 🧰 MariaDB Example

```ini
[config]
host=your-mariadb-host
port=3306
username=teamspeak
password=STRONG_PASSWORD
database=teamspeak
socket=
```

The container also **non‑destructively** updates `ts3server.ini` (`dbplugin=ts3db_mariadb`, `dbsqlpath=/teamspeak/sql/`, `dbsqlcreatepath=create_mariadb/`, host/user/password/keepalive).

---

## 🏷️ Tags

- `latest` – most recent stable build  
- `vX.Y.Z` – release tag build  
- `3.13.7` – TeamSpeak version used for validation  
- `YYYY.MM.DD` – build date

Architecture: ✅ `linux/amd64`

---

## 🔗 Links

- Docker Hub: https://hub.docker.com/r/blackbandit1804/teamspeak-mariadb  
- GitHub Source: https://github.com/Blackbandit1804/ts3-mariadb  
- Unraid Template: https://github.com/Blackbandit1804/docker-templates  
- TeamSpeak: https://www.teamspeak.com

---

## 📎 Origin / Credits

This image is **not** built FROM `ich777/docker-teamspeak` — it’s an independent build.  
It follows a similar pattern (UID/GID/UMASK), and adds: MariaDB integration, automatic INIs, `gosu` startup, `TS_VER`/`TS_URL` logic.
