# The brute-force strategy refutes every anti-rule for each update.
# With m (anti-)rules, each n-page update costs Θ(m)O(n) = O(mn) runtime.

# Read until `\n\n` inclusive
anti_rules = ARGF.readline('')
  .scan(/(\d++)\|(\d++)/) #: Array[[String, String]]
  .map { /(\D|\A)#{_2}\D(.*?\D)?#{_1}\D/ }

puts ARGF.sum {|update| if anti_rules.any? { update.match? _1 }
  0
else
  Integer(update[/(\d++,(\g<1>|(\d++)),\d++)/, 3] || update)
end }
