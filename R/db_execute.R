
#' Run SQL script from file
#' @export
run_sql_script = function(conn, filename, start_date=NA, end_date=NA) {
  sqls = parse_sql_script(filename)

  lapply(sqls, function(sql) {
    if (is.na(start_date) | is.na(end_date)) {
      dbExecute(conn, sql)
    } else {
      s = glue::glue_sql(sql, .con=conn, start_date=start_date, end_date=end_date)
      dbExecute(conn, s)
    }
  })
}
