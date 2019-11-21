#!/usr/bin/env Rscript

library(odbc)
library(DBI)
library(argparser)
library(dbhelper)
library(glue)

dt = as.character(Sys.Date())
dt_prev = as.character(Sys.Date() - 1)
p = arg_parser('Run SQL from file or text input')
p = add_argument(p, "dsn", help='DSN')
p = add_argument(p, "sql_script", help='SQL script')
p = add_argument(p, "--start_date", help='Start date as YYYY-MM-DD', default=dt_prev)
p = add_argument(p, "--end_date", help='End date as YYYY-MM-DD', default=dt)
args = parse_args(p)

sqlite = dbConnect(odbc(), 'sqlite')
conn = dbConnect(odbc(), dsn=args$dsn)
sqls = parse_sql_script(args$sql_script)
lapply(sqls, function(sql) {
  s = glue_sql(sql, .con=conn, start_date=args$start_date, end_date=args$end_date)
  dbExecute(conn, s)
})
dbDisconnect(conn)
