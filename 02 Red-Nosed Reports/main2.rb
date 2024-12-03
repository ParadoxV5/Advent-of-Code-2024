SAFE_RANGES = [+1..+3, -3..-1]

def get_delta(levels, delta_index)
  left, right = delta_index
  levels.fetch(right) - levels.fetch(left)
end

puts ARGF.count {|line|
  levels = line.split.map(&:to_i)
  delta_groups = levels.each_index
    .each_cons(2) #: Enumerator[delta_index, untyped]
    .group_by do|delta_index|
      delta = get_delta(levels, delta_index)
      SAFE_RANGES.find { _1.include? delta }
    end
  
  popular_range = SAFE_RANGES.max_by { delta_groups[_1]&.size or 0 } #: safe_range
  delta_groups.delete popular_range
  outlier_indices = delta_groups.values.flatten(1)
  
  case outlier_indices
  # Part 1: All deltas must belong to one safe range group
  # Part 2: Allow one unsafe delta at the edge
  in [] | [[0, _]] | [[_, ^(levels.size.pred)]]
    true
  # Part 2: Allow two consecutive unsafe deltas that’re safe without the middle level
  in [[a, b], [^b, c]]
    popular_range.include? get_delta levels, [a, c]
  # Part 2: Allow one unsafe delta with one tolerable level
  in [[a, b]]
    [[a.pred, b], [a, b.succ]].any? { popular_range.include? get_delta levels, _1 }
  else
  end
}
