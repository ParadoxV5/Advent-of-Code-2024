# Repeatable reference to of a region (currently only one {Integer}, the {#perimeter})
class Region
  GARDEN = ARGF.map do|line|
    row = line.chars #: Array[String?]
    row[-1] = nil
    row
  end << []
  
  attr_accessor :perimeter
  attr_reader :side_next_points
  def initialize
    self.perimeter = 0
    @side_next_points = Array.new(4) { Set.new }
  end
  def sides = @sides ||= side_next_points.sum(&:size)
  
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
  GARDEN.each_with_index {|row, y| row.each_with_index {|plot, x| flood_fill(
      plot, #: String
    x, y) if plot } }
  region_table = GARDEN #: Array[Array[Region?]]
  
  # Calculate {#perimeter} (Part 1) and number of sides (Part 2)
  region_table.each_with_index do|row, y|
    row.each_with_index do|plot, x|
      next unless plot
      neighbors = neighbors x, y
      plot.perimeter += neighbors.each_with_index.count do|(x2, y2), i|
        # Part 1 {#perimeter}: number of side plots to non-{#equal?} plots
        next if plot.equal? GARDEN.fetch(y2)[x2]
        # For Part 2, the direct approach would hashtally every point
        # in the perimeter and compare how many sides they comprise.
        # But intriguingly, since these nested loops consistently iterate indices left-to-right–top-to-bottom,
        # I can match it by inline-checking side points left-to-right and top-to-bottom.
        # This allows me to track only the latest point of each previous side.
        next_points = plot.side_next_points.fetch i
        # Remove old record of matching side
        # check even indices top-to-bottom (`y.pred`), check odd ones left-to-right (`x.pred`)
        next_points.delete neighbors.fetch ~(i%2)
        # Add new record, whether for old side or new
        next_points.add [x, y]
        true
      end
    end
  end
  
  # The area of a plot is also the number of times it’s references in plots,
  # which means it gets natually multipled when I double-triple count plots in this undeduped {Array#sum}mation.
  # This is why I’m not tracking areas explicitly.
  puts(
    'Part 1',
    region_table.sum {|row| row.sum { it ? it.perimeter : 0 } },
    'Part 2',
    region_table.sum {|row| row.sum { it ? it.sides : 0 } }
  )
end
