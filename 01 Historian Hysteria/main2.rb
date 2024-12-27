left, right = ARGF # .each_line
  .map(&:split) # rows of columns
  .transpose #: [Array[String], Array[String]] # columns of rows

# Index the right list
# * Somehow my left list is all unique numbers,
#   So I don’t index it, assuming it’s intended to be mostly if not all unique.
# * Don’t multiply yet, assuming the right set is not a subset of the left
right_index = right.tally
puts left.sum { right_index[it]&.* it.to_i or 0 }
