#!/usr/bin/env -S bash -e

echo Running mssql-conf setup...
/opt/mssql/bin/mssql-conf -n setup accept-eula
