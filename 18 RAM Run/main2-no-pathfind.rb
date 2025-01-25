# An alternate apporach is to connect up (including diagonally) the corruptions.
# If the corruptions forms a rift whose endpoints are on the memory space borders,
# it divides the space into two regions.
# And if this division cuts from the top/right edge to the bottom/left, it separates the exit from the entrance.

max_x = max_y = 70 # Example: 6
# Implementation: track each dropped corruption as either
# * a Symbol – either `:top_right` or `:bottom_left`, or gameover if both
# * an Array shared among neighbors that records its neighborhood when it’s not connected to the edges.
corruptions = Hash.new do|hash, (x, y)| #$ Array[Integer], :top_right|:bottom_left|Array[coords], coords, :top_right|:bottom_left|nil
  if y.negative? or x > max_x
    :top_right
  elsif x.negative? or y > max_y
    :bottom_left
  end
end

ARGF.each_line do|line|
  x, y = corruption = line.split(',', 2).map(&:to_i) #: [Integer, Integer]
  neighbors = Enumerator.product([x.pred, x, x.succ], [y.pred, y, y.succ])
    .filter_map(&corruptions)
    .uniq
    .group_by(&:class)
  
  edge, edge2 = neighbors[Symbol] #: Array[:top_right|:bottom_left]
  break puts line if edge2 # steep:ignore BreakTypeMismatch
  neighborhoods = neighbors[Array] #: Array[Array[coords]]?
  
  corruptions[corruption] = if edge # new connection
    neighborhoods&.each {|neighborhood| neighborhood.each { corruptions[_1] = edge } }
    edge
  elsif neighborhoods.nil?
    [corruption] # Population: 1
  elsif neighborhoods.size == 1
    neighborhoods.first << corruption
  else
    mega_neighborhood = neighborhoods.flatten(1)
    neighborhoods.each {|neighborhood| neighborhood.each { corruptions[_1] = mega_neighborhood } }
    mega_neighborhood
  end
end
