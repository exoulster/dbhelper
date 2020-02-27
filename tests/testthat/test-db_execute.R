library(RSQLite)

test_that('break_into_chunks', {
  expect_equal(break_into_chunks(as.Date('2020-01-01'), as.Date('2020-02-22')),
               list(start_dates=c(as.Date('2020-01-01'), as.Date('2020-02-01')),
                    end_dates=c(as.Date('2020-02-01'), as.Date('2020-02-22'))))
  expect_equal(break_into_chunks(as.Date('2020-02-01'), as.Date('2020-02-22')),
               list(start_dates=c(as.Date('2020-02-01')),
                    end_dates=c(as.Date('2020-02-22'))))
})

test_that('run_sql', {
  sqlite = dbConnect(SQLite())
  sql = "
  drop table if exists test;
  create table if not exists test (
    id int,
    name string
  )
  ;

  insert into test(id, name)
  values
    (1, 'jonas'),
    (2, 'iris')
  ;
  "
  run_sql(sqlite, sql)

  expect_equal(dbGetQuery(sqlite, 'select * from test') %>% nrow(), 2)

  dbDisconnect(sqlite)
})

test_that('run_sql_script', {
  sqlite = dbConnect(SQLite())

  sql_file = 'test-sql.sql'
  run_sql_script(sqlite, sql_file)

  expect_equal(dbGetQuery(sqlite, 'select * from test') %>% nrow(), 2)

  dbDisconnect(sqlite)
})


