# Reminds me of Vanellope von Schweetz
cheat_distances = 2..20 # Part 1: 2..2, Part 2: 2..20

start = [0, 0] #: [Integer, Integer]
# The map is bordered on all sides.
map = ARGF.each_line(chomp: true).with_index.map do|line, y| # steep:ignore ArgumentTypeMismatch
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
  # 100 minimum net savings (Part 2 Example: 50)
  .lazy.drop(100) #: Enumerator[[Integer, Integer], void]
  .each_with_index # deduct that 100 from the index `picosecond2`
  .sum do|(y, x), picosecond0| # count missed cheats
    cheat_distances.sum do|cheat_distance|
      max_picosecond = picosecond0 - cheat_distance # and deduct the cheat’s own distance
      (0...cheat_distance).sum do|d1|
        d2 = cheat_distance - d1
        [
          [y+d1, x+d2],
          [y-d2, x+d1],
          [y-d1, x-d2],
          [y+d2, x-d1]
        ].count do|coordz2|
          next if coordz2.any?(&:negative?) # Skip negative underflows (positive overflows {Array#dig} into `nil`)
          picosecond2 = map.dig(*coordz2)
          picosecond2 and picosecond2 <= max_picosecond
        end
      end
    end
  end
)
