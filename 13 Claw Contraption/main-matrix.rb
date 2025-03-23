# I feel like revisiting this mathematically introductory puzzle with some better maffing.
# 
# How many times we press each button makes a space of 2D lattice points,
# and where the claw is is another space of X-Y coordinates.
# Linear Transformations can map from one space to another
# [and vice versa too](https://www.youtube.com/watch?v=uQhTuRlWMxw&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab).
# 
# Matrix mathematics lead to the same computations as Cramer’s rule in `main.rb`.
# Here the emphasis is on 3Blue1Brown’s “we usually get software to compute this stuff anyway.”
require 'matrix'
PART2 = true

puts(ARGF.each('').sum do|input|
  # First of all, convert the input to vector components – for actual vectors this time
  a_x, a_y, b_x, b_y, prize_x, prize_y = input.scan(/\d++/) #: Array[String]
    .map(&:to_i) #: [Integer, Integer, Integer, Integer, Integer, Integer]
  if PART2
    prize_x += 10000000000000
    prize_y += 10000000000000
  end
  
  # Build Linear Transformer, apply its inverse to the prize coörds, and extract the result
  ans = Matrix[[a_x, b_x], [a_y, b_y]].inverse * Vector[prize_x, prize_y]
  ans.all? { it.denominator == 1 } ? 3 * ans[0].numerator + ans[1].numerator : 0
rescue ExceptionForMatrix::ErrNotRegular => cause
  raise 'not implemented', cause:
end)
