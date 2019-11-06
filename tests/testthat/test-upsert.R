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

test_that("upsert", {
  conn = dbConnect(SQLite())
  upsert(conn, name='upsert', value=ori_dfr, pk='id', verbose=TRUE)
  upsert(conn, name='upsert', value=new_dfr, pk='id', verbose=TRUE)
  expect_equal(tbl(conn, 'impt_upsert') %>% pull(label), c('n','y','n','y','n'))
  dbDisconnect(conn)
})
