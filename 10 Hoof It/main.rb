PART2 = true

# I thought we’re [hiking](https://adventofcode.com/2022/day/12) ourselves for a good movement.
map = ARGF.readlines # keep newlines as padding
map << '' # pad columns too

# The score of a trailhead is the number of its trailtails,
# and the goal is to find the total score… so basically the number of 0–9 trails.
# simple DFS– no wait! BFS is way cooler here…
# Hmm, actually, BFS is the way to go because we don’t want to count the same coords twice in Part 1.
puts map.each_with_index.sum {|row, y|
  row.each_char.with_index.sum do|cell, x|
    next 0 unless cell == '0'
    here = [[x, y]] #: Array[[Integer, Integer]]
    ('1'..'9').each do|next_cell|
      here = here.flat_map do|x, y|
        [
          [x.pred, y],
          [x.succ, y],
          [x, y.pred],
          [x, y.succ]
        ] #: Array[[Integer, Integer]]
      end
      here.uniq! unless PART2
      here.keep_if { map.fetch(_2)[_1] == next_cell }
    end
    here.size
  end
}
