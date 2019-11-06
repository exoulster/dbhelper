#' Init Oracle DB
#' @export
get_oracle_conn = function() {
  conn = DBI::dbConnect(ROracle::Oracle(),
                        username=Sys.getenv("ORACLE_USERNAME"),
                        password=Sys.getenv("ORACLE_PASSWORD"),
                        dbname=Sys.getenv("ORACLE_TNS")
  )
  conn
}


#' Init Oracle DB Pool
#' @export
get_oracle_pool = function() {
  conn = pool::dbPool(ROracle::Oracle(),
                      username=Sys.getenv("ORACLE_USERNAME"),
                      password=Sys.getenv("ORACLE_PASSWORD"),
                      dbname=Sys.getenv("ORACLE_TNS")
  )
  conn
}
