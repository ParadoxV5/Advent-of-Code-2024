# Repeatable reference to of a region (currently only one {Integer}, the {#perimeter})
class Region
  GARDEN = ARGF.map do|line|
    row = line.chars #: Array[String?]
    row[-1] = nil
    row
  end << []
  
  attr_accessor :perimeter
  def initialize
    self.perimeter = 0
  end
  # price per area
  alias to_i perimeter
  
  # Common helper: get neighboring coords of coords
  def self.neighbors(x, y) = [
    [x.succ, y],
    [x, y.succ],
    [x.pred, y],
    [x, y.pred]
  ]
  
  # Flood Fill that replace {GARDEN} plots with regions
  # @param region will create {.new} if `nil`
  def self.flood_fill(plant, x, y, region = nil)
    row = GARDEN.fetch(y)
    return unless row[x] == plant
    row[x] = region ||= new
    neighbors(x, y).each { flood_fill(plant, _1, _2, region) }
  end
  # Flood Fill all regions
  GARDEN.each_with_index do|row, y|
    row.each_with_index {|plot, x| flood_fill(plot, x, y) if plot.is_a? String }
  end
  
  # Calculate area and {#perimeter}
  # * area: number of references in plots – which means the number of repeated
  #   counts in this pre-deduped {Array#sum}mation, so I’m not tracking it here
  # * {#perimeter}: number of edges to non-{#equal?} plots
  puts GARDEN #: Array[Array[Region?]]
    .each_with_index {|row, y|
      row.each_with_index {|plot, x| plot&.perimeter +=
        neighbors(x, y).count { not plot.equal? GARDEN.fetch(_2)[_1] }
      }
    }.sum { it.sum(&:to_i) }
end
