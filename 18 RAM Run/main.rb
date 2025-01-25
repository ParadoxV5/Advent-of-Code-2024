PART2 = false

EXIT_X, EXIT_Y = 70, 70 # Example: 6, 6
# {Float::INFINITY} replacement
MAX_DISTANCE = EXIT_X*EXIT_Y + 1

# Array of arrays or hashset of corruptions?
# Well, experience from this year’s prior days showed that a 2D array can also store supplementary data –
# Day 6: Loop detection
# Day 16: Dijkstra’s distance
MAP = EXIT_X.succ.then {|width| Array.new(EXIT_Y.succ) { Array.new(width, MAX_DISTANCE) } }
input = ARGF.each_line
input = input.lazy.take(1024) unless PART2 # Example: 12
input.each do|line|
  x, y = line.split(',', 2).map(&:to_i) #: coords
  MAP.fetch(y)[x] = nil
end
MAP.first[0] = 0

FRONTIER = Set[[0, 0]] #: Set[coords]
def dijkstra_bfs = while (x, y = here = FRONTIER.min_by do|x, y|
  MAP.fetch(y).fetch(x) #: Integer
end)
  distance = MAP.fetch(y).fetch(x) #: Integer
  return distance if x >= EXIT_X and y >= EXIT_Y
  FRONTIER.delete here
  
  distance += 1
  [
    [x.succ, y     ],
    [x     , y.succ],
    [x.pred, y     ],
    [x     , y.pred]
  ] #: Array[coords]
    .each do|here2|
      x2, y2 = here2
      next unless (0..EXIT_X).include? x2 and (0..EXIT_Y).include? y2 # I should stop using the paddings hack
      if MAP.fetch(y2)[x2]&.> distance
        MAP.fetch(y2)[x2]= distance
        FRONTIER << here2
      end
    end
end

puts(if PART2
else
  dijkstra_bfs
end)
