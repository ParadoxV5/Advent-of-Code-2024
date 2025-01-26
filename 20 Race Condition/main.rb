# Reminds me of Vanellope von Schweetz
start = [0, 0] #: [Integer, Integer]
# The map is bordered on all sides (so wrapping off one edge will land you on top of the other edge).
map = ARGF.each_line(chomp: true).with_index.map do|line, y|
  # Integer = visited, nil = unvisited, false = off-track
  line.each_char.with_index.map do|position, x| #$ Integer?|false
    case position
    when '#'
      next false
    when 'S'
      start = [y, x]
    end
    nil
  end
end

# We’re given that there’s only one path (a racetrack, not a maze), so linear iteration will do.
picosecond = -1
puts(
  Enumerator.produce(start) do|y, x| #$ [Integer, Integer]
    map.fetch(y)[x] = (picosecond += 1)
    # move forward
    [
      [y     , x.succ],
      [y.succ, x,    ],
      [y     , x.pred],
      [y.pred, x,    ]
    ].find { map.dig(*it).nil? } || (raise StopIteration) #: [Integer, Integer]
  end
  # Won’t have enough distance to backtrack a cheat to until we’ve run
  # 100 minimum net savings + 2 minimum cheat distance
  .lazy.drop(102)
  .each_with_index # deduct that 100+2 from the index `max_picosecond`
  .sum do|(y, x), max_picosecond| # count missed cheats
    [
      [y  , x-2],
      [y-2, x  ],
      [y  , x+2],
      [y+2, x  ]
    ].count do|coordz2|
      picosecond2 = map.dig(*coordz2)
      picosecond2 and picosecond2 <= max_picosecond
    end
  end
)
