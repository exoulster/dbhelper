
#' Run SQL script from file
#' @param filename file name with full path
#' @param start_date start date in format YYYY-MM-DD
#' @param end_date end date in format YYYY-MM-DD
#' @param by period definition in string
#' @export
run_sql_script = function(conn, filename, start_date=NA, end_date=NA) {
  st = Sys.time()
  sqls = parse_sql_script(filename)

  lapply(sqls, function(sql) {
    if (is.na(start_date) | is.na(end_date)) {
      dbExecute(conn, sql)
    } else {
      s = glue::glue_sql(sql, .con=conn, start_date=start_date, end_date=end_date)
      dbExecute(conn, s)
    }
  })
  et = Sys.time()
  mins = round(difftime(et, st, units='mins'), 2)
  msg = glue::glue('successfully processed records from {start_date} to {end_date} in {mins} minutes',
                   start_date=start_date, end_date=end_date, mins=mins)
  message(msg)
}


#' Run SQL script by period
#' @param filename file name with full path
#' @param start_date start date in format YYYY-MM-DD
#' @param end_date end date in format YYYY-MM-DD
#' @param by period definition in string
#' @export
run_sql_script_by = function(conn, filename, start_date, end_date, by='month') {
  rng = seq.Date(from=start_date, to=end_date, by=by)
  rng2 = c(rng[2:length(rng)], end_date)
  mapply(function(sd, ed) {
    if (sd != ed) {
      run_sql_script(conn, filename, sd, ed)
    }
  }, rng, rng2)
}
