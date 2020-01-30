test_that('remove_comments', {
  expect_equal(stringr::str_replace('select * /* this is the comment */ \n from ', '\\/\\*.*\\*\\/', ''),
               'select *  \n from '
  )
  expect_equal(stringr::str_replace_all('select * -- comment1 \n from table -- comment2', '\\-\\-.*', ''),
               'select * \n from table '
  )
})
