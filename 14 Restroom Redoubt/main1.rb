# Mafs… after the previous day, this one’s a welcome *rest*.
puts ARGF.filter_map {|line|
  px, py, vx, vy = line.scan(/-?\d++/) #: Array[String]
    .map(&:to_i) #: [Integer, Integer, Integer, Integer]
  area = [
    (px + vx*100) % 101 <=> 50, # 101/2
    (py + vy*100) % 103 <=> 51  # 103/2
  ]
  area if area.none?(&:zero?)
}.tally.each_value.inject(:*)
