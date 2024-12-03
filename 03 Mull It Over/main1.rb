# Way too easy in Ruby; are we cheating?
puts ARGF.read #: String
  .scan(/mul\((\d++),(\d++)\)/) #: Array[[String, String]]
  .sum { Integer(_1) * Integer(_2) }
