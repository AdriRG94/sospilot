#!/bin/bash
#
# ETL for reset.
#
# Set Stetl options

. ../options.sh

options="$pg_options sql_files=reset-weewx2pg.sql"

echo "options = [$options]"

stetl -c ../sql-exec.cfg -a "$options"


