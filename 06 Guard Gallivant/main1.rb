# Nothing to think here. Simulate, period.

# keep newlines so both `line[-1]` and `line[line.chomp.size]` gives neither `.` nor `#`
map = ARGF.readlines
# and have a similar padding for rows too
map << ''

pos = 0i
map.each_with_index do|row, j| # https://bugs.ruby-lang.org/issues/20899
  if (i = row.index '^')
    pos = Complex.rect i, j
  end
end
vel = -1i

count = 1 # 1 for the current space just marked with `X`
loop do
  pos2 = pos + vel
  case map.fetch(pos2.imag)[pos2.real]
  when '#'
    vel *= 1i # +Y is down!
    redo
  when '.'
    count += 1 # about to step to an unvisited cell
  when 'X'
    # do_nothing()
  else # where are we?
    puts count
    exit
  end
  
  map.fetch(pos.imag)[pos.real] = 'X'
  pos = pos2
end
