# Generalization: https://www.youtube.com/watch?v=-UrdExQW0cs&t=1105

puts ARGF.each('').sum {|input|
  # First of all, convert the input to vector – I mean, {Complex} constants
  a, b, prize = input.scan(/\w++: X\W(\d++), Y\W(\d++)/) #: Array[[String, String]]
    .map { Complex.rect Integer(_1), Integer(_2) } #: [Complex, Complex, Complex]
  
  # Let a combination be `mA + nB = P`; rearrange and we have `n = (P - Am) ÷ B`.
  # Our goal is to minimize this linear relation:
  # ```
  #   3m + 1n
  # = 3m + (P - Am) ÷ B
  # = 3m - (A/B)m + P/B
  # = (3-A/B)m + P/B ∈ ℝ
  # ```
  # There can be multiple solutions only if A is a real multiple of B; that is, `A/B ∈ ℝ`.
  # Since it’s linear, it hints us that for these cases,
  # we prefer Bs over As if `3 > A/B ∈ ℝ` or prefer As if `3 < A/B`.
  # `A/B < 3` seems *much* more likely, so to reduce the times I iterate from an overëstimate,
  # I guess-and-check from “Let m be 0” for this case.
  enum = 0..100 #: Enumerable[Integer]
  enum = enum.reverse_each if (a/b).real > 3
  enum.find do|m| # https://bugs.ruby-lang.org/issues/20899
    n_r, n_i = ((prize - a*m) / b).rect
    break 3*m + n_r if n_i.zero? and n_r.is_a? Integer
  end or 0
}
