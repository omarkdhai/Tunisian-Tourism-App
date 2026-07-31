#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE user_db;
    CREATE DATABASE place_db;
    CREATE DATABASE trip_db;
    CREATE DATABASE review_db;
    CREATE DATABASE budget_db;
    CREATE DATABASE notification_db;
EOSQL
