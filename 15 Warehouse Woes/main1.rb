# Task: implement [Baba is You push mechanics][baba]
# [baba]: https://www.reddit.com/r/adventofcode/comments/1hetsol/2024_day_15_solution_in_baba_is_you/

map = readline('', chomp: true).lines(chomp: true)
x = y = 0
map.each_with_index do|row, j| # https://bugs.ruby-lang.org/issues/20899
  if (i = row.index '@')
    x, y = i, j
    break
  end
end

ARGF.each_char.lazy.filter_map(&(
  {
    '^' => [ 0, -1],
    'v' => [ 0,  1],
    '<' => [-1,  0],
    '>' => [ 1,  0]
  } #: Hash[String, [Integer, Integer]]
)).each do|dx, dy|
  # robot next pos if successful
  x2, y2 = x+dx, y+dy
  # exclusive other end of the box chain ➡ inclusive other end
  x3, y3 = x2, y2
  # I could shift the `O`s one-by-one, or I can just find the other end of a box chain.
  while (cell3 = (row3 = map.fetch(y3))[x3]) == 'O'
    x3 += dx
    y3 += dy
  end
  next if cell3 == '#' # bonk
  row3[x3] = 'O' unless x3 == x2 and y3 == y2 # only if there were box(es)
  map.fetch(y2)[x2] = '@'
  map.fetch(y )[x ] = '.'
  x, y = x2, y2
end

puts map.each_with_index.sum {|row, j|
  row.each_char.with_index.sum { _1 == 'O' ? 100*j + _2 : 0 }
}
