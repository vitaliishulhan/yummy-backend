#!/bin/sh
set -e

echo "Starting PostgreSQL seeder..."

if [ "$RUN_SEED" != "true" ]; then
  echo "RUN_SEED is not true. Skipping seeding."
  exit 0
fi

echo "Waiting for PostgreSQL to be ready..."
until pg_isready -h "$PGHOST" -U "$PGUSER"; do
  sleep 2
done

echo "PostgreSQL is ready. Running initialization script..."

psql \
  -h "$PGHOST" \
  -U "$PGUSER" \
  -d "$PGDATABASE" \
  -f ./init.sql

echo "Seeding completed successfully."
