library(odbc)
library(DBI)
library(argparser)
library(dbhelper)

p = arg_parser('Run SQL from file or text input')
p = add_argument(p, "command", help="Create Table As Select")
p = add_argument(p, "--dsn", help="DSN")
p = add_argument(p, "--sql_file", help="SQL file")
p = add_argument(p, "--sql_text", help="SQL text")
p = add_argument(p, "--suffix", help="suffix")

args = parse_args(p)
# print(args)

sqlite = dbConnect(odbc(), 'sqlite')
conn = dbConnect(odbc(), dsn=args$dsn)
ctas(conn, sql_file=args$sql_file, sql_text=args$sql_text, suffix=args$suffix)
dbDisconnect(conn)
