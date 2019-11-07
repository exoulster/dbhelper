#!/usr/bin/env Rscript

library(odbc)
library(DBI)
library(argparser)
library(dbhelper)

p = arg_parser('Run SQL from file or text input')
p = add_argument(p, "dsn", help='DSN')
p = add_argument(p, "sql_script", help='SQL script')
args = parse_args(p)

# sqlite = dbConnect(odbc(), 'sqlite')
conn = dbConnect(odbc(), dsn=args$dsn)
sqls = parse_sql_script(args$sql_script)
lapply(sqls, function(sql) {
  dbExecute(conn, sql)
})
dbDisconnect(conn)
