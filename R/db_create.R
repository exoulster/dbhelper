#' get sql query
#' @export
parse_sql_script = function(sql_script) {
  s = readr::read_file(sql_script)
  s = trimws(s)
  sqls = strsplit(s, '\\;')[[1]]
  sqls
}


#' create table as select
#' @export
ctas = function(conn, sql_file=NA, sql_text=NA, remove_suffix=NA) {
  if (!is.na(sql_file)) {
    s = readr::read_file(sql_file)
    s = trimws(s)
    sqls = strsplit(s, '\\;')[[1]]

    # verify if table name and file name matches
    table = stringr::str_remove(basename(sql_file), '.sql')
    res = lapply(sqls, function(sql) {
      stringr::str_detect(sql, table)
    })
    if (!all(unlist(res))) stop('not all query contain ', table)
  }
  else if (!is.na(sql_text)) {
    s = sql_text
    s = trimws(s)
    sqls = strsplit(s, '\\;')[[1]]
  }
  else stop('either sql_file or sql_text should be provided')


  # run sql
  lapply(sqls, function(sql){
    DBI::dbExecute(conn, sql)
  })

  if (!is.na(remove_suffix)) {
    table.new = stringr::str_remove(table, paste0('_', remove_suffix))
    DBI::dbExecute(conn, paste("drop table if exists", table.new))
    DBI::dbExecute(conn, paste("alter table", table, "rename to", table.new))
  }
}
