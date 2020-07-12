#' @export
format_period_unit = function(unit, lang='cn') {
  unit_mapping = c(
    'second' = '秒',
    'minute' = '分钟',
    'hour' = '小时',
    'day' = '天',
    'week' = '周',
    'month' = '月',
    'year' = '年'
  )

  u = lubridate:::parse_period_unit(unit)
  u.n = u$unit
  if (lang=='cn') {
    u.unit = unit_mapping[u$unit]
  } else {
    u.unit = u$unit
  }

  if (u.n==1) {
    u.unit
  } else {
    paste(u.n, u.unit)
  }
}
