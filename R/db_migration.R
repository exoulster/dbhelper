
#' Migrate table from source to target
#' @param source_conn source db connection
#' @param target_conn target db connection
#' @param source_table source table name
#' @param source_schema source schema
#' @param target_schema target schema
#' @import dplyr
#' @export
db_migrate = function(source_conn, target_conn, source_table, source_schema=NULL, target_schema=NULL, overwrite=TRUE) {
  dfr = dplyr::tbl(source_conn, dbplyr::in_schema(source_schema, source_table)) %>% collect()
  if (class(target_conn) == 'OraConnection') {
    names(dfr) = names(dfr) %>% toupper()
    target_table = toupper(source_table)
    target_schema = toupper(target_schema)
  } else if (class(target_conn) %in% c('Impala', 'Hive')) {
    names(dfr) = names(dfr) %>% tolower()
    target_table = tolower(source_table)
    target_schema = tolower(target_schema)
  }
  DBI::dbWriteTable(target_conn, name=target_table, schema=target_schema, value=dfr, overwrite=overwrite)
}


db_dump = function(conn, table, schema, output_location) {
  dfr = dplyr::tbl(conn, dbplyr::in_schema(schema, table)) %>% collect()
  names(dfr) = tolower(names(dfr))
  readr::write_excel_csv(dfr, output_location)
}
