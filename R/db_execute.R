
#' Run SQL script from file
#' @export
run_sql_script = function(conn, filename, start_date=NULL, end_date=NULL) {
  sqls = parse_sql_script(filename)
  if (is.null(start_date)) start_date = as.character(Sys.Date() - 1)
  if (is.null(end_date)) end_date = as.character(Sys.Date())
  lapply(sqls, function(sql) {
    s = glue::glue_sql(sql, .con=conn, start_date=start_date, end_date=end_date)
    dbExecute(conn, s)
  })
}
