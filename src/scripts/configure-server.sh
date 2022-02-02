#!/usr/bin/env -S bash -e

MSSQL_EDITION="${1}"
MSSQL_SA_PASSWORD="${2}"

echo Running mssql-conf setup...
sudo MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD \
     MSSQL_PID=$MSSQL_PID \
     /opt/mssql/bin/mssql-conf -n setup accept-eula
