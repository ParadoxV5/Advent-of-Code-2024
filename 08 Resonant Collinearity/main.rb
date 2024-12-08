antennas = {}  #: Hash[String, Array[Complex]]
widths = ARGF.each_line(chomp: true) # steep:ignore ArgumentTypeMismatch
  .with_index
  .map do|row, y|
    row.each_char.with_index do|frequency, x|
      unless frequency == '.'
        antennas.fetch(frequency) { antennas[_1] = [] } << Complex.rect(x, y)
      end
    end
    row.size
  end

in_range = ->(antinode) do
  x, y = antinode.rect
  !y.negative? and y < widths.size and !x.negative? and x < widths.fetch(y)
end

puts antennas.each_value.flat_map {|group|
  group.combination(2) #: Enumerator[[Complex, Complex], untyped]
    .flat_map do|u, v|
      d = v - u
      t = u - d
      w = v + d
      
      if false #: bool # Part 1
        [t, w].select(&in_range)
      else # Part 2
        [
          *(t..).step(-d).take_while(&in_range),
          u,
          v,
          *(w..).step( d).take_while(&in_range)
        ]
      end
    end
}.uniq.size
