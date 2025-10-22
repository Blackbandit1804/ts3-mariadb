machine_id=
default_voice_port=9987
voice_ip=
licensepath=
filetransfer_port=30033
filetransfer_ip=
query_port=10011
query_ip=0.0.0.0, ::
query_ip_allowlist=query_ip_allowlist.txt
query_ip_denylist=query_ip_denylist.txt

# Standard: SQLite – wird durch ENV (TS3_DB_HOST) auf MariaDB umgestellt
dbplugin=ts3db_sqlite3
dbpluginparameter=
dbsqlpath=sql/
dbsqlcreatepath=create_sqlite/
dbconnections=10

logpath=logs/
logquerycommands=1
dbclientkeepdays=30
logappend=1
query_skipbruteforcecheck=0
query_buffer_mb=20
http_proxy=
license_accepted=1
serverquerydocs_path=serverquerydocs/
query_ssh_ip=0.0.0.0, ::
query_ssh_port=10022
query_protocols=raw
query_ssh_rsa_host_key=ssh_host_rsa_key
query_timeout=300
