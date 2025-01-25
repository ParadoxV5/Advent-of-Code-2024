# String matching? Don’t mind if I do~ (Oh, don’t worry about
# [the performance](https://www.ruby-lang.org/en/news/2022/12/25/ruby-3-2-0-released/#:~:text=Improved%20Regexp%20matching%20algorithm)
# of our {Regexp} engine – Ruby is magnitudes faster than those Pythonistic rumors of last decade.)

# somehow `….enum_for(:scan, /…/).count` is _slow_
puts ARGF.count(&/\A(#{readline('').scan(/\w++/).join '|'})*\Z/.method(:match?))

# See Part 2 for what a native implementation (with memoization) looks like.
