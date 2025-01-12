# *insert Image Detection AI*

pxs, pys, vxs, vys = ARGF.map do|line|
  line.scan(/-?\d++/) #: Array[String]
  .map(&:to_i) #: [Integer, Integer, Integer, Integer]
end.transpose #: [list, list, list, list]
mx, my = 101, 103

def minimum_entropy(ps, vs, modulus) = Enumerator.produce(ps) do|pos|
  pos.each_with_index.map { (_1 + vs.fetch(_2)) % modulus }
end.lazy
  .take(modulus)
  .with_index
  .max_by do|pos, _iteration|
    # To select the frame that make the best ‘image’,
    # many use [entropy](https://en.wikipedia.org/wiki/Entropy_(information_theory)?oldid=1268623470)
    # as [their heuristic](https://www.reddit.com/r/adventofcode/comments/1hf3qdw/):
    # H(X) = -∑(x∈X) { P(X,x) × log P(X,x) }
    pos.tally.each_value.sum { it * it.bit_length } # Use {Integer#bit_length} as a fast {Math::log2}
  end || raise('empty sequence?')

pxs, fx = minimum_entropy pxs, vxs, mx
pys, fy = minimum_entropy pys, vys, my

# Render
robots_tally = pxs.zip(pys).tally
my.times do|y|
  mx.times {|x| print(
    if (n = robots_tally[[x, y]]) #: Integer?
      n < 10 ? n : '#'
    else
      '.'
    end
  ) }
  puts
end

# [孙子’s Theorem](https://en.wikipedia.org/wike/Chinese_remainder_theorem?oldid=1266785314):
# With pairwise-coprime integer divisors `n[i]` and their integer remainders `a[i]`
# (`0 ≤ a[i] < n[i]`), there exists one and only one dividend within `0...∏(n)`.
# Finding this exact dividend Guess-and-check isn’t straightforward;
# even Guess-and-Check (Θ(n^i)) is about as efficient.
puts (fy...mx*my).step(my).find { it % mx == fx }
