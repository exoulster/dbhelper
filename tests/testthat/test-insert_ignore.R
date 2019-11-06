library(RSQLite)
library(dplyr)

ori_dfr = data.frame(
  id = c(1,2,3),
  label = c('y','n','y')
)

new_dfr = data.frame(
  id = c(3,4,5),
  label = c('n','y','n')
)

test_that("insert_ignore", {
  conn = dbConnect(SQLite())
  insert_ignore(conn, name='insert_ignore', value=ori_dfr, pk='id', verbose=TRUE)
  insert_ignore(conn, name='insert_ignore', value=new_dfr, pk='id', verbose=TRUE)
  expect_equal(tbl(conn, 'impt_insert_ignore') %>% pull(label), c('y','n','y','y','n'))
  dbDisconnect(conn)
})


