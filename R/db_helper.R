
split_table_name = function(conn=NULL, table_name) {
  table_name_txt = table_name %>%
    strsplit('.', fixed=TRUE) %>%
    .[[1]]

  if (!is.null(conn)) {
    if (class(conn) == 'OraConnection') {
      table_name_txt = toupper(table_name_txt)
    }
  }

  if (length(table_name_txt)==1) { # does not contain schema, use default from option
    schema = NULL
    table_name = table_name_txt[1]
  } else {
    schema = table_name_txt[1]
    table_name = table_name_txt[2]
  }

  return(list(schema=schema, table=table_name))
}


#' Set Default Database
#' @param schema schema name
#' @export
use = function(schema) {
  schema_enq = rlang::enquo(schema)
  schema_txt = rlang::quo_text(schema_enq)
  options(dbhelper.schema=schema_txt)
  message(paste('default schema', schema_txt, 'is set'))
}

#' List Databases
#' @param schema schema name
#' @param conn connection object. Will search global environment for "con" if conn is NULL
#' @import dplyr
list_databases = function(conn=NULL) {
  return()
}


#' List Tables
#' @param schema schema name
#' @param conn connection object. Will search global environment for "con" if conn is NULL
#' @import dplyr
#' @export
list_tables = function(conn=NULL, schema=NULL, pattern='.*') {
  if (is.null(conn)) {
    if (is.null(globalenv()$con)) stop('con is not available, please set up connection')
    conn = globalenv()$con
  }

  if (is.null(schema)) {
    schema = getOption('dbhelper.schema')
    message(paste('Listing tables from schema', schema))
  }

  DBI::dbListTables(conn, schema=schema) %>%
    .[stringr::str_detect(., pattern)] %>%
    sort()
}


#' List fields of a table
#' @param table_name table name
#' @export
list_fields = function(conn=NULL, table_name, schema=NULL) {
  DBI::dbListFields(conn, table_name, schema=schema)
}


#' Connect DB Table
#' @param table_name table name, could be full name with schema
#' @param conn connection object. Will search global environment for "con" if conn is NULL
#' @export
tbbl = function(conn, table_name) {
  if (is.null(conn)) {
    if (is.null(globalenv()$con)) stop('con is not available, please set up connection')
    conn = globalenv()$con
  }
  table_name_txt = split_table_name(conn=conn, table_name=table_name)
  schema = table_name_txt[1]
  table = table_name_txt[2]

  if (is.null(schema)) {
    dplyr::tbl(conn, table)
  } else {
    dplyr::tbl(conn, dbplyr::in_schema(schema, table))
  }
}


#' get sql query
#' @export
parse_sql_script = function(sql_script) {
  s = readr::read_file(sql_script)
  s = trimws(s)
  sqls = strsplit(s, '\\;')[[1]]
  lapply(sqls, dplyr::sql)
}
