#' Get data.frame/tibble from sql
#' @param conn database connection
#' @param sql_statement sql statement to run. Only single statement is supported at this moment.
#' @param ... parameters in the form of key=value. This will substitute '${}' in the original sql
#' @export
get_query = function(conn, sql_statement, ...) {
  if (missing(sql_statement)) {
    stop('sql_statement is missing')
  }
  if (length(list(...))==0) {
    interpolation = FALSE
  } else {
    interpolation = TRUE
  }

  sql = sql_statement
  if (!inherits(sql, 'sql')) {
    sql = parse_sql(sql) # cleanup sql
  }

  if (length(sql) > 1) {
    stop('only single sql statement is supported')
  }

  if (interpolation) {
    sql = glue::glue_sql(sql, .con=conn, ...)
  }
  sql = stringr::str_replace_all(sql, '`', '')

  dfr = DBI::dbGetQuery(conn, statement=sql)
  dplyr::as_tibble(dfr)
}
