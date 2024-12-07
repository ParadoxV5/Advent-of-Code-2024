# Ruby has {Array#repeated_permutation},
# but recalculating the whole equation for one change is quite wasteful.
def operable?(target, lhs, *rhs)
  last_rhs = rhs.pop
  if last_rhs
    (
      operable? target - last_rhs, lhs, *rhs # Part 1
    ) or (
      div, mod = target.divmod last_rhs
      operable? div, lhs, *rhs if mod.zero? # Part 1
    ) or (
      if (lhalf = target.to_s.delete_suffix! last_rhs.to_s)
        # Note: API design-wise, do not accept a String cache – AoC input has trailing `:`s.
        operable? lhalf.to_i, lhs, *rhs # Part 2
      end
    )
  else # `rhs.empty?`
    target == lhs
  end
end

puts ARGF.sum {|line|
  numbers = line.split.map &:to_i
  if operable?(*numbers)
    numbers.first
  end or 0
}
