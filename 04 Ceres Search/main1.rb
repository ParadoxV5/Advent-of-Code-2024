# Noob: Iterate every row, column, diagonal and backward
# Pro:  Look for neighboring Xs, Ms, As & Ss

# keep newlines so both `line[-1]` and `line[line.chomp.size]` gives a non-‘XMAS’ char
input = ARGF.readlines
# and have a similar padding for rows too
input << ''

steps = [
  [+1,  0],
  [+1, +1],
  [ 0, +1],
  [-1, +1],
  [-1,  0],
  [-1, -1],
  [ 0, -1],
  [+1, -1]
] #: Array[[Integer, Integer]]

puts input.each_with_index.sum {|row, y0|
  row.size.times.sum do|x0|
    steps.count do|dx, dy|
      x, y = x0, y0
      'XMAS'.each_char.all? do|chr|
        if input.fetch(y)[x] == chr
          x += dx
          y += dy
        end
      end
    end
  end
}
