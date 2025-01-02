PART2 = true

# * Each stone with the same number transforms to stone(s) with the same number.
# * Stones do not affect each others’ transformations. (We don’t care how they space themselves.)
# 
# This means, with the power of lunatic magic,
# I can pause the time of stones and resume them depth-first in the order of my preference.

class Stone
  STONES = Hash.new { _1[_2] = new _2 }
  def initialize(number)
    @number = number
  end
  
  def nexts = @next ||= if @number.zero? # Rule 1
    [1]
  elsif (digits = @number.digits).size.even? # Rule 2
    # “the first element of the array represents the least significant digit”
    [digits.pop(digits.size/2), digits].map do|subdigits|
      # [undigits](https://bugs.ruby-lang.org/issues/18762)! 😄
      subdigits.reverse_each.reduce {|acc, subdigit| acc*10 + subdigit }
    end
  else # Rule 3
    [@number * 2024]
  end.map { STONES[it] }
  
  def count_after_blinks = @count_after_blinks ||= Hash.new do|hash, blinks|
    blinks2 = blinks.pred
    hash[blinks] = nexts.sum { it.count_after_blinks[blinks2] }
  end.tap { it[1] = nexts.size }
  
  blink_count = PART2 ? 75 : 25
  puts ARGF.each(' ').sum { STONES[Integer it].count_after_blinks[blink_count] }
end
