#!/usr/bin/env -S bash -e

echo Installing mssql-tools and unixODBC developer...
ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev msodbcsql17
