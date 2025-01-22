# This is a script tailored for my input; your mileage may vary.
readline('') # ignore the registers’ initialization
OUTPUT = readline.scan(/\d/) #: Array[String]
  .reverse_each.map(&:to_i)

# Observations:
# * The program is a single loop with a single print.
# * Each iteration calculates its output from the least-significant octal digit of A and then shifts it away when done.
# * Each output is determined from the current octal digit and unspecific bits that are not yet shifted.
#   * These bits are zero for the last couple of iterations, which are for the most-significant digits.
# Therefore, these octal digits are deducible starting from the most-significant.
def push_deduction(current = 0, index = 0)
  output = OUTPUT.fetch(index) { return current }
  index += 1
  current <<= 3 # revert `0,3`
  # https://bugs.ruby-lang.org/issues/20899
  (0b000..0b111).lazy.filter_map do|b|
    a = current + b # revert `2,4`
    b ^= 0b001 # `1,1`
    c = (a >> b) & 0b111 # `7,5` & `5,*`
    b ^= c # `4,7`
    push_deduction(a, index) if b ^ 0b110 == output # `1,6` & revert `5,5`
  end.first
end

puts push_deduction || raise('no solution')
