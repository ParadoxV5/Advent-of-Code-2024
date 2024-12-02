puts ARGF.count {|line|
  levels = line.split.map(&:to_i)
  safe_range = if levels.fetch(0) < levels.fetch(1) # Increasing
    +1..+3
  else # Decreasing or non-changing (break later)
    -3..-1
  end
  levels.each_cons(2) #: Enumerator[[Integer, Integer], untyped]
    .all? { safe_range.include?(_2 - _1) }
}
