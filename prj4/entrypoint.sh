#!/bin/bash
set -e
if [ find ./opt/postgres -name \* -o -name .\* ] 
then 
/usr/pgsql-11/bin/initdb -D /opt/postgres/
fi
mv /opt/pg_hba.conf /opt/postgres/pg_hba.conf
/usr/pgsql-11/bin/pg_ctl -D /opt/postgres/ start
echo "postgres good"
psql -f /etc/datomic-pro-1.0.6610/bin/sql/postgres-db.sql -U postgres
psql -f /etc/datomic-pro-1.0.6610/bin/sql/postgres-table.sql -U postgres -d datomic
psql -f /etc/datomic-pro-1.0.6610/bin/sql/postgres-user.sql -U postgres -d datomic
/usr/pgsql-11/bin/pg_ctl -D /opt/postgres/ stop
/usr/pgsql-11/bin/postgres -D /opt/postgres/
echo "datomic good"