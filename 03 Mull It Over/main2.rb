# Still too easy in Ruby; we might be cheating.
enabled = true #: bool
sum = 0
ARGF.read #: String
  .scan(/mul\((\d+),(\d+)\)|do(n't)?\(\)/) do|matches|
    a, b, nt = matches #: Array[String]
    if a # mul
      sum += Integer(a) * Integer(b) if enabled
    else
      enabled = !nt # don't
    end
  end
puts sum
