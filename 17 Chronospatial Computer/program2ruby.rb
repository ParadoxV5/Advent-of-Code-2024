# für Part 2

puts 'OUT = []', readline('').gsub(/Register (\w++):\s+/, '$\1 = ')
PROGRAM = (ARGF.read or raise EOFError).scan(/\d/) #: Array[String]

def get_combo(operand) = case operand
  when '4' then '$A'
  when '5' then '$B'
  when '6' then '$C'
  when '7' then "raise(NotImplementedError, 'combo operand 7')"
  else operand
end
def puts_instructions(inclusive_begin = 0, exclusive_end = PROGRAM.size, indent: nil)
  PROGRAM.lazy.take(exclusive_end).drop(inclusive_begin).each_slice(2) do|instruction, operand|
    raise EOFError unless operand
    puts [
      indent,
      case instruction
      when '0' #adv
        ['$A >>= ', get_combo(operand)]
      when '1' # bxl
        ['$B ^= 0b', sprintf('%#.3b', operand)]
      when '2' # bst
        ['$B = ', get_combo(operand), ' & 0b111']
      when '3' # jnz
        [
          operand.to_i >= PROGRAM.size ? 'exit' : ['jnz', operand],
          ' unless $A.zero?'
        ]
      when '4' # bxc
        '$B ^= $C'
      when '5' # out
        ['OUT << (', get_combo(operand), ' & 0b111)']
      when '6' # bdv
        ['$B = $A >> ', get_combo(operand)]
      when '7' # cdv
        ['$C = $A >> ', get_combo(operand)]
      else
        raise ArgumentError, "unknown instruction #{instruction.inspect}"
      end
    ].join
  end
end

labels = PROGRAM.each_slice(2).filter_map do|instruction, operand|
  (operand or raise EOFError) if instruction == '3' # jnz
end
puts(if labels.empty? # fast path
  puts_instructions
  nil
else
  
  odd_labels, even_labels = labels.to_set do|label|
    [label.to_i, PROGRAM.size].min
  end.merge([0, PROGRAM.size]).sort.partition(&:odd?)

  raise NotImplementedError, 'odd jnz’s are not yet supported' unless odd_labels.empty?

  even_labels.each_cons(2) #: Enumerator[[Integer, Integer], Array[Integer]]
    .each do|inclusive_begin, exclusive_end|
      puts meth = "def jnz#{inclusive_begin}"
      puts_instructions inclusive_begin, exclusive_end, indent: '  '
      puts 'end', nil
    end
  'jnz0'
end, "puts OUT.join ','")
