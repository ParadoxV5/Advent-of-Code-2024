puts 25.times.reduce(ARGF.each(' ').map(&:to_i)) {|stones, _i|
  stones.flat_map do|stone|
    # Rule 1
    next 1 if stone.zero?
    # Rule 2
    digits = stone.digits
    if digits.size.even?
      # “the first element of the array represents the least significant digit”
      [digits.pop(digits.size/2), digits].map do|subdigits|
        # [undigits](https://bugs.ruby-lang.org/issues/18762)! 😄
        subdigits.reverse_each.reduce {|acc, subdigit| acc*10 + subdigit }
      end
    # Rule 3
    else
      stone * 2024
    end
  end
}.size
