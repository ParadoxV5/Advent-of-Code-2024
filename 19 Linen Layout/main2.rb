towels = readline('').scan(/\w++/) #: Array[String]

# Memoization cache with some pre-allocated capacity
permutations = Hash.new(capacity: towels.size**3) do|hash, new_design| #$ String, Integer, String, Integer
  hash[new_design] = towels.sum do|prefix_design|
    subdesign = new_design.delete_prefix prefix_design
    subdesign.size < new_design.size ? hash[subdesign] : 0
  end
end
#towels.each { permutations[it] = 1 } # only if no towel patterns overlap, which isn’t this day
permutations[''] = 1

puts ARGF.each_line(chomp: true) # steep:ignore ArgumentTypeMismatch
  .sum(&permutations)
