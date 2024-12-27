# The safe bet is to build a tailored insertion sort.
# However, it looks like the orderings of every pair of page numbers are given,
# which means any sorting algorithm works on this totally ordered set.

# Read until `\n\n` inclusive, then chomp it off
rulebook = ARGF.readline('', chomp: true) #steep:ignore ArgumentTypeMismatch
rules = rulebook.each_line(chomp: true) # chomp newlines off for consistency
  .to_h { [it, -1] } # Most if not all implementations implement {Set} with a {Hash}, so might as well…

if $DEBUG
  # Assert the pre-condition
  rulebook.scan(/\d++/) #: Array[String]
    .uniq
    .combination(2) do |a, b|
      unless rules.include? "#{a}|#{b}" or rules.include? "#{b}|#{a}"
        raise "rules does not specify ordering of #{a} and #{b}"
      end
    end
end

rulebook = '' # GC

part1 = part2 = 0

ARGF.each_line(chomp: true) {|line| #steep:ignore ArgumentTypeMismatch
  update = line.split ','
  # Part 1: Θ(1)Θ(is_sorted(n)) = Θ(n) runtime per update
  unless (was_sorted = update.each_cons(2) #: Enumerator[[String, String], untyped]
    .all? { rules.include? "#{_1}|#{_2}" }
  )
    # Part 2: Θ(1)Θ(sort(n)) = Θ(n log n) runtime per update
    update.sort! { rules.fetch("#{_1}|#{_2}", +1) }
  end
  middle = Integer update.fetch update.size/2
  if was_sorted
    part1 += middle
  else
    part2 += middle
  end
}

puts(
  'Part 1',
  part1,
  'Part 2',
  part2
)
