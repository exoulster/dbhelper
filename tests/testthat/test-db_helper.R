test_that('remove_comments', {
  expect_equal(remove_comments('select * /* this is the comment */ \n from '),
               'select *  \n from ')
  expect_equal(remove_comments('select * -- comment1 \n from table -- comment2'),
               'select * \n from table ')
})

test_that('replace_double_quotes', {
  expect_equal(replace_double_quotes('select * from table where order_id = ""'),
               "select * from table where order_id = ''")
})

test_that('replace_var', {
  expect_equal(replace_vars('select * from table where day = ${start_date}'),
               'select * from table where day = {start_date}')
})
