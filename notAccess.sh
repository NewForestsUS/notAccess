#!/bin/bash
# Inspired by
# https://www.codeenigma.com/community/blog/using-mdbtools-nix-convert-microsoft-access-mysql

# USAGE
# Rename your MDB file to migration-export.mdb
# run ./mdb2sqlite.sh migration-export.mdb
# wait and wait a bit longer...

mdb-schema --drop-table $1 postgres > schema.sql

for i in $( mdb-tables $1 ); do echo $i ; mdb-export -D "%Y-%m-%d %H:%M:%S" -H -q "'" -I postgres $1 $i > sql/$i.sql; done

psql -d $2 -f schema.sql #| sqlite3 $2

for f in sql/* ; do echo psql -d $2 -f $f ; done
