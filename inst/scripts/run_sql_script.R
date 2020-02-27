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
p = add_argument(p, "--start_date", help='Start date as YYYY-MM-DD' )
p = add_argument(p, "--end_date", help='End date as YYYY-MM-DD')
p = add_argument(p, "--by", help='Process by batch month/day/etc')
args = parse_args(p)

sqlite = dbConnect(odbc(), 'sqlite')
conn = dbConnect(odbc(), dsn=args$dsn)
run_sql_script(conn, filename=args$sql_script,
               start_date=args$start_date, end_date=args$end_date,
               by=args$by)
dbDisconnect(conn)
