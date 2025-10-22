# TeamSpeak 3 Server (MariaDB-ready) – Unraid friendly

**Image:** `blackbandit1804/teamspeak-mariadb`  
**Getestet auf:** Unraid 7.1.4  
**Basis:** TS3 Server 3.13.7 mit MariaDB-Plugin und gosu statt sudo  

---

## 🧭 Startbeispiel (Docker CLI)

```bash
docker run -d --name TeamSpeak3-MariaDB \
  --restart unless-stopped \
  -p 9987:9987/udp -p 10011:10011 -p 30033:30033 \
  -e TS3SERVER_LICENSE=accept \
  -e EXTRA_START_PARAMS="inifile=/teamspeak/ts3server.ini" \
  -e UID=99 -e GID=100 -e UMASK=000 -e DATA_PERM=770 \
  -v /mnt/cache/appdata/teamspeak3:/teamspeak \
  blackbandit1804/teamspeak-mariadb:latest
