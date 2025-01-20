#!/bin/bash

set -e
cd /

# Ensure the script only runs once
if [ -f /tmp/entrypoint.lock ]; then
  echo "Script already executed. Exiting."
  exit 0
fi
touch /tmp/entrypoint.lock

# Start PostgreSQL in a screen session
screen -dmS postgres sudo -u postgres /usr/lib/postgresql/15/bin/postgres --config-file=/etc/postgresql/15/main/postgresql.conf

# Start nginx in a screen session
screen -dmS nginx nginx -g 'daemon off;'

# Wait for PostgreSQL to start
echo "Waiting for PostgreSQL to start up..."
until sudo -u postgres psql -c "SELECT 1 as id" > /dev/null 2>&1; do
  sleep 0.1
done
echo "PostgreSQL is ready!"

# Set the PostgreSQL user's password if not already set
sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='postgres'" | grep -q 1 || \
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres'"

# Create the app database if it doesn't exist
DB_EXISTS=$(sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='app'" | tr -d '[:space:]')
if [ "$DB_EXISTS" != "1" ]; then
  sudo -u postgres psql -c "CREATE DATABASE app"
  echo "Database 'app' created."
else
  echo "Database 'app' already exists."
fi

# Run /sundai/run.sh if it exists
if [ -f /sundai/run.sh ]; then
  echo "Running /sundai/run.sh..."
  bash /sundai/run.sh
  if [ $? -ne 0 ]; then
    echo "/sundai/run.sh returned a non-zero exit code. Exiting with error."
    exit 1
  else
    echo "/sundai/run.sh executed successfully."
  fi
else
  echo "File /sundai/run.sh not found."
fi

# Keep the container alive for interactive use
echo "Container is now running and ready for interaction."
tail -f /dev/null
