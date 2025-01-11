# Numbers are too huge for guess-and-check, so it’s time for *actual* mafs.
# For the “generalization” linked in `main1.rb`,
# if not for the noise added to the target, this mafs can even break that encryption.
PART2 = true

puts ARGF.each('').sum {|input|
  # First of all, convert the input to vector _components_
  a_x, a_y, b_x, b_y, prize_x, prize_y = input.scan(/\d++/) #: Array[String]
    .map(&:to_i) #: [Integer, Integer, Integer, Integer, Integer, Integer]
  if PART2
    prize_x += 10000000000000
    prize_y += 10000000000000
  end
  
  # Almost busted out linear (de-)transformations. ᗡx
  # ```
  # mA⃗ + nB⃗ = P⃗
  # ⎰ m×A_x + n×B_x = P_x
  # ⎱ m×A_y + n×B_y = P_y
  # ```
  # Cramer’s rule summarizes the general solution to systems of linear equations.
  det = a_x*b_y - b_x*a_y
  # (unlikely) ∞ solutions (given that both ‘lines’ of the system starts from the origin)
  # Procedule: [Find a reference solution with Bézout's identity](https://math.stackexchange.com/a/20727),
  # then find the link’s `r` that minimizes `3m + 1n`.
  raise 'not implemented' if det.zero?
  # one unique solution
  m = Rational(prize_x*b_y - b_x*prize_y, det)
  next 0 unless m.denominator.equal? 1
  m_n = m.numerator
  n = Rational(prize_x - m_n*a_x, b_x)
  next 0 unless n.denominator.equal? 1
  3*m_n + n.numerator
}
