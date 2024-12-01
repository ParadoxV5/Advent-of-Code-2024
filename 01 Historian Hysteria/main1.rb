puts ARGF # .each_line
  .map{ _1.split.map(&:to_i) } # rows of columns
  .transpose # columns of rows
  .each(&:sort!) # columns of sorted rows
  .transpose # sorted rows of columns
  .sum { (_1 - _2).abs }
