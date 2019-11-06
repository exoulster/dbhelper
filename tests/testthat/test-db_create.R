library(odbc)
library(DBI)

impala = dbConnect(odbc(), 'impala:oyo_risk')
f = 'tmp/oyo_dm_risk.dwd_users.sql'

test_that('db_create', {

})
