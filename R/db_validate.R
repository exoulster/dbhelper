
#' @import dplyr rlang
is_unique = function(data, ...) {
  fields_enq = quos(...)
  if (length(fields_enq)==0) stop('Enter at least 1 field')
  dups = data %>%
    group_by(!!!fields_enq) %>%
    count() %>%
    filter(n >= 2) %>%
    collect()
  nr = nrow(dups)
  validate_that(nr==0, msg=paste(nr, 'duplicate keys found'))
}
