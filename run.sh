#!/bin/bash

set -e
cd /

# Start PostgreSQL in a screen session
screen -dmS postgres sudo -u postgres /usr/lib/postgresql/15/bin/postgres --config-file=/etc/postgresql/15/main/postgresql.conf

# Start nginx in a screen session
screen -dmS nginx nginx -g 'daemon off;'

# wait for postgres to start
echo "Waiting for PostgreSQL to start up..."
until sudo -u postgres psql -c "SELECT 1 as id" > /dev/null 2>&1; do
  sleep 0.1
done
echo "PostgreSQL is ready!"

# make sure postgres user has password
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres'"

# create app database if it doesn't exist
sudo -u postgres psql -c "CREATE DATABASE app" || true

# Run /sundai/run.sh if it exists
if [ -f /sundai/run.sh ]; then
  echo "Running /sundai/run.sh..."
  bash /sundai/run.sh
else
  while true; do
    echo "running..."
    sleep 60
  done
fi
