#' Insert ignore by primary key
#' @import DBI dplyr
#' @export
insert_ignore = function(conn, name, value, pk, verbose=FALSE) {
  tmp_table = paste('tmp', name, sep='_')
  impt_table = paste('impt', name, sep='_')
  data = value %>%
    mutate(batch_id = Sys.time() %>% format('%Y%m%d.%H%M%S'))

  # do cleanup (tmp_table)
  if (dbExistsTable(conn, tmp_table)) {
    dbRemoveTable(conn, tmp_table)
  }

  # exists impt?
  if (!dbExistsTable(conn, impt_table)) {
    # create new
    if (verbose) message(paste('insert to', impt_table))
    dbWriteTable(conn, name=impt_table, value=data, overwrite=TRUE)
  } else {
    # import tmp table
    if (verbose) message(paste('import to', tmp_table))
    dbWriteTable(conn=conn, name=tmp_table, value=data, overwrite=TRUE)

    # increment
    if (verbose) message('generate incremental records')
    incr = tbl(conn, tmp_table) %>%
      anti_join(tbl(conn, impt_table), by=pk) %>%
      collect()
    nr = incr %>% count() %>% pull()
    if (verbose) message(paste(nr, 'rows to insert to', impt_table))
    dbWriteTable(conn, name=impt_table, value=incr, append=TRUE)

    # remove tmp
    if (verbose) message(paste('remove', tmp_table))
    dbRemoveTable(conn, name=tmp_table)
  }
}


#' Upsert by primary key
#' @import DBI dplyr
#' @export
upsert = function(conn, name, value, pk, verbose=FALSE) {
  tmp_table = paste('tmp', name, sep='_')
  impt_table = paste('impt', name, sep='_')
  data = value %>%
    mutate(batch_id = Sys.time() %>% format('%Y%m%d.%H%M%S'))

  # do cleanup (tmp_table)
  if (dbExistsTable(conn, tmp_table)) {
    dbRemoveTable(conn, tmp_table)
  }

  # exists impt?
  if (!dbExistsTable(conn, impt_table)) {
    # create new
    if (verbose) message(paste('insert to', impt_table))
    dbWriteTable(conn, name=impt_table, value=data, overwrite=TRUE)
  } else {
    # import tmp table
    if (verbose) message(paste('import to', tmp_table))
    dbWriteTable(conn=conn, name=tmp_table, value=data, overwrite=TRUE)

    # increment
    if (verbose) message('generate incremental records')
    incr = tbl(conn, impt_table) %>%
      anti_join(tbl(conn, tmp_table), by=pk) %>%
      collect()
    nr = incr %>% count() %>% pull()
    if (verbose) message(paste(nr, 'rows to insert to', tmp_table))
    dbWriteTable(conn, name=tmp_table, value=incr, append=TRUE)

    # remove impt
    if (verbose) message(paste('remove', impt_table))
    dbRemoveTable(conn, name=impt_table)

    # rename tmp to impt
    if (verbose) message(paste('rename', tmp_table, 'to', impt_table))
    sql = paste('alter table', tmp_table, 'rename to', impt_table)
    res = dbSendStatement(conn, sql)
    dbClearResult(res)
  }
}
