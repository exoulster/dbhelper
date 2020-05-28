
break_into_chunks = function(start_date, end_date, by='month') {
  rng = seq.Date(from=start_date, to=end_date, by=by)
  if (length(rng)>=2) {
    rng2 = c(rng[2:length(rng)], end_date)
  } else {
    rng2 = end_date
  }
  list(
    start_dates = rng,
    end_dates = rng2
  )
}


#' Run SQL script from file
#' @param conn database connection
#' @param sql_statement sql statement to run. Multiple sql statements should be seperated by semicolon(;)
#' @param filename file name with full path
#' @param by period definition in string
#' @export
run_sql = function(conn, sql_statement, ...,
                   start_date=NA, end_date=NA, by=NA, offset=NA,
                   verbose=FALSE) {
  if (missing(sql_statement)) {
    stop('sql_statement is missing')
  }
  if (!is.na(offset)) {
    offset = as.numeric(offset)
  }
  if (length(list(...))==0 & is.na(start_date) & is.na(end_date)) {
    interpolation = FALSE
  } else {
    interpolation = TRUE
  }
  st = Sys.time()

  sqls = sql_statement
  if (!inherits(sqls, 'sql')) {
    sqls = parse_sql(sqls) # cleanup sql
  }

  # dates
  if (is.na(end_date)) {
    end_date = Sys.Date()
  }

  if (is.na(start_date)) {
    if (is.na(offset)) {
      start_date = Sys.Date() - 1
    } else {
      start_date = end_date + offset
    }
  }

  f = function(conn, sqls, ..., start_date=NA, end_date=NA, verbose=FALSE) {
    lapply(sqls, function(sql){
      if (interpolation) {
        s = glue::glue_sql(sql, .con=conn, ...,
                           start_date=start_date, end_date=end_date)
      } else {
        s = sql
      }

      DBI::dbExecute(conn, s)
      if (verbose) {
        message('sql executed: ', s)
      }
    })
  }

  # run by chunk
  if (is.na(by)) {
    f(conn=conn, sqls=sqls, ..., start_date=start_date, end_date=end_date, verbose=verbose)
  } else {
    rng = break_into_chunks(start_date=start_date, end_date=end_date, by=by)
    mapply(function(sd, ed) {
      tm = system.time(f(conn=conn, sqls=sqls, ..., start_date=sd, end_date=ed, verbose=verbose))
      message('data from ', sd, ' to ', ed, ' processed in ', round(tm[[3]]/60, 2), ' minutes')
    }, rng$start_dates, rng$end_dates)
  }

  et = Sys.time()
  mins = round(difftime(et, st, units='mins'), 2)
  msg = glue::glue('successfully sql in {mins} minutes', mins=mins)
  message(msg)

  return(TRUE)
}

#' @rdname run_sql
#' @export
run_sql_script = function(conn, filename, ...,
                          start_date=NA, end_date=NA, by=NA, offset=NA,
                          verbose=FALSE) {
  sqls = parse_sql_script(filename)
  run_sql(conn=conn, sql=sqls, ...,
          start_date=start_date, end_date=end_date, by=by, offset=offset,
          verbose=verbose)
}


#' @rdname run_sql
#' @export
run_sql_script_by = function(conn, filename, start_date, end_date, by='month') {
  run_sql_script(conn=conn, filename=filename, start_date=start_date, end_date=end_date, by=by)
}
