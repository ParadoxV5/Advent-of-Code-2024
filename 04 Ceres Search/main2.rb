# keep newlines so both `line[-1]` and `line[line.chomp.size]` gives a non-‘XMAS’ char
input = ARGF.readlines
# and have a similar padding for rows too
input << ''

as = Set['M', 'S']

puts input.each_with_index.sum {|row, y0|
  # {Array#count} instead of {Array#sum} because each ‘A’ is only enough for one X-MAS
  row.each_char.with_index.count do|chr, x0|
    next unless chr == 'A'
    x9, x1, y9, y1 = x0.pred, x0.succ, y0.pred, y0.succ
    (
      as == Set[input.fetch(y9)[x9], input.fetch(y1)[x1]]
    ) and (
      as == Set[input.fetch(y9)[x1], input.fetch(y1)[x9]]
    )
  end
}
