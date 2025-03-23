# > The first rule, 47|53,
# > means that if an update includes both page number 47 and page number 53,
# > then page number 47 must be printed at some point before page number 53.
# 
# This specifically means:
# * It’s correct if it only has either 47 or 53 but not both.
# * It’s correct if it has neither 47 nor 53.
# * It’s only incorrect if it prints 53 before 47.
# 
# Therefore, it’s easier to treat the rules as anti-rules
# and refute updates that match any anti-rule.

# My input has m > 1K (anti-)rules while each update has n < 25 < √(1K) pages.
# Therefore, I feature this rule-indexing strategy.
# Each update compares every pair of pages for Θ(1)Θ(nCr(n, 2)) = Θ(n²) runtime.

# Read until `\n\n` inclusive, then chomp it off
rules = ARGF.readline('', chomp: true)
  .each_line(chomp: true) # chomp newlines off for consistency
  .to_set

puts ARGF.each_line(chomp: true).sum {|line| #steep:ignore ArgumentTypeMismatch
  update = line.split ','
  if (update
    .combination(2) # assuming order within subset matches order in array (not explicitly documented)
    .any? { rules.include? "#{_2}|#{_1}" }
  )
    0
  else
    Integer update.fetch(update.size/2)
  end
}
