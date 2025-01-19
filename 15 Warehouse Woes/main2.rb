# Vertical chains are now heterogenous trees. Time to actually implement Baba is You push mechanics!

x = y = 0
MAP = gets('', chomp: true) #: String
  .each_line(chomp: true).with_index.map do|line, j|
    line.gsub(/./).with_index do|tile, i|
      case tile
      when 'O'
        '[]'
      when '@'
        x, y = i*2, j
        '..'
      else
        tile * 2
      end
    end
  end

# Each push must validate the entire tree before applying changes.
# To save the second iteration, I cache changes in a hashmap.
# The same map can also identify visited boxes, which makes DFS more trivial than BFS.
def check_vertical_push(x, y, dy, changelist)
  # “Diamond Problem”
  return true if changelist.key? [x, y] # if truthy, should only be '.' in a DFS
  x1, x2 = case MAP.fetch(y)[x]
  when '.'
    return true
  when '['
    [x, x.succ]
  when ']'
    [x.pred, x]
  else
    return
  end
  y2 = y+dy
  if check_vertical_push(x1, y2, dy, changelist) and check_vertical_push(x2, y2, dy, changelist)
    changelist[[x1, y2]] = '['
    changelist[[x2, y2]] = ']'
    changelist[[x1, y]] = changelist[[x2, y]] = '.'
  end
end


ARGF.each_char {|move| case move
when '<'
  x -= 1 if MAP.fetch(y).sub!(/\.((?:\[\])*)(?<=\A.{#{x}})/) { "#{$1}." }
when '>'
  x += 1 if MAP.fetch(y).sub!(/\A.{#{x}}.\K((?:\[\])*+)\./)  { ".#{$1}" }
when '^', 'v'
  dy = move == 'v' ? 1 : -1
  y2 = y + dy
  changelist = {} #: changelist
  next unless check_vertical_push x, y2, dy, changelist
  changelist.each {|(x0, y0), change| MAP.fetch(y0)[x0] = change }
  y = y2
end }

puts MAP.each_with_index.sum {|row, j|
  row.each_char.with_index.sum { _1 == '[' ? 100*j + _2 : 0 }
}
