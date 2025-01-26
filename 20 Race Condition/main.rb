# Reminds me of Vanellope von Schweetz
x = y = 0
# The map is bordered on all sides (so wrapping off one edge will land you on top of the other edge).
map = ARGF.each_line(chomp: true).with_index.map do|line, j|
  # Integer = visited, nil = unvisited, false = off-track
  line.each_char.with_index.map do|position, i| #$ Integer?|false
    case position
    when '#'
      next false
    when 'S'
      x, y = i, j
    end
    nil
  end
end

# We’re given that there’s only one path (a racetrack, not a maze), so linear iteration will do.
(0..) #: Range[Integer]
  .reduce(0) {|cheats, picosecond|
    #@type break: void
    map.fetch(y)[x] = picosecond
    picosecond -= 102 # backtrack 2 + 100 savings to check
    
    # count missed cheats
    cheats += [
      [y  , x-2],
      [y-2, x  ],
      [y  , x+2],
      [y+2, x  ]
    ].count do|coordz2|
      picosecond2 = map.dig(*coordz2)
      picosecond2 and picosecond2 <= picosecond
    end
    
    # move forward
    y, x = [
      [y     , x.succ],
      [y.succ, x,    ],
      [y     , x.pred],
      [y.pred, x,    ]
    ].find { map.dig(*it).nil? } || (break puts cheats) #: [Integer, Integer]
    
    cheats
  }
