# What is challenging though is building an Regexp that looks around
# to eliminate all disabled false-positives; yet by Santa, I did it!
puts ARGF.read #: String
  .scan(%r{
      (
        # Match `…don't()…do()`
        don't\(\)
        .*?
        do\(\)
      |
        # Match nothing since last match
        \G
      )
      # Then match as long as it doesn’t have `don't()` (and `mul(…)`) in it
      ((?~
        don't\(\)
        |
        mul\(\d++,\d++\)
      ))
      mul\((\d++),(\d++)\)
    }mx) #: Array[[String, String, String, String]]
  .sum {|dont_do, skip, a, b|
    p dont_do, skip if $DEBUG
    Integer(a) * Integer(b)
  }
