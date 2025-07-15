#!/bin/bash

# set +ex

# $HIVE_HOME/bin/schematool -dbType postgres -initSchema
# $HIVE_HOME/hcatalog/sbin/hcat_server.sh start &

# sleep 20

# $HIVE_HOME/bin/hiveserver2 --hiveconf hive.root.logger=Info,console &

# /usr/bin/tail -f /dev/null


#!/bin/bash

set +e

echo "🔍 Checking PostgreSQL connectivity..."

PG_HOST="postgres"
PG_PORT=5432
PG_DB="metastore"
PG_USER="hive"
PG_TIMEOUT=5

pg_isready -h $PG_HOST -p $PG_PORT -d $PG_DB -U $PG_USER -t $PG_TIMEOUT > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ PostgreSQL is not reachable at $PG_HOST:$PG_PORT. Exiting."
  exit 1
else
  echo "✅ PostgreSQL is reachable."
fi

echo "🔍 Checking Hive schema state..."
$HIVE_HOME/bin/schematool -dbType postgres -info > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "⛏️ Initializing Hive schema..."
  $HIVE_HOME/bin/schematool -dbType postgres -initSchema
else
  echo "✅ Hive schema already initialized."
fi

echo "🚀 Starting Hive Metastore..."
$HIVE_HOME/hcatalog/sbin/hcat_server.sh start &
sleep 10

echo "🔍 Verifying Hive Metastore Thrift endpoint..."
RETRIES=10
until nc -z localhost 9083 || [ $RETRIES -eq 0 ]; do
  echo "⏳ Waiting for Hive Metastore Thrift to be available at localhost:9083..."
  sleep 2
  RETRIES=$((RETRIES - 1))
done

if [ $RETRIES -eq 0 ]; then
  echo "❌ Hive Metastore Thrift did not start on port 9083."
  exit 1
else
  echo "✅ Hive Metastore Thrift is up and reachable at thrift://localhost:9083"
fi

echo "🚀 Starting HiveServer2..."
$HIVE_HOME/bin/hiveserver2 --hiveconf hive.root.logger=INFO,console &

tail -f /dev/null



