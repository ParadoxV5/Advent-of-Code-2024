# Good o’ Maze Solving!
# Note that the best path is not necessarily the shortest path – a direct but
# zigzagging diagonal is worse than a large detour with only a couple of turns.
# With a map much narrower than 1000÷4 = 250, it should the path with the fewest
# turns, though those are relatively harder to minimize than Taxicab Distance.

QueuedNode = Data.define :pos, :vel
class QueuedNode
  # This does not contain nodes currently having infinite distance – the map tracks ’em.
  node_set = Set.new #$ instance & _Integer
  finish = 0i
  
  # Don’t need a trailing `\n` because the maze is fully closed.
  MAP = ARGF.each_line(chomp: true).with_index.map do|line, y|
    line.each_char.with_index.map do|char, x|
      east_cell = case char
      when '#'
        next
      when 'S'
        node_set << (
          new(Complex.rect(x, y), 1.to_c) #: instance & _Integer
        )
        0
      when 'E'
        finish = Complex.rect x, y
        nil
      end
      cells = [1.to_c, 1i, -1.to_c, -1i].to_h {[ _1, Float::INFINITY ]} #$ Complex, score
      cells[1.to_c] = east_cell if east_cell
      cells
    end
  end
  
  def cell = MAP.dig pos.imag, pos.real, vel
  
  parents = Hash.new { _1[_2] = [] } #: Hash[instance, Array[instance]]
  here = nil
  # Part 1: Dijkstra’s implemented as a maze solver (i.e., hybrid with BFS)
  while (here = node_set.min_by(&:cell))
    pos, score = here.pos, here.cell
    # Pedantically all 4 directions should be checked, but we get to cheat here.
    break puts 'Part 1', score if pos.eql? finish
    node_set.delete here
    
    vel = here.vel
    [
      [pos+vel, vel, 1   ],
      [pos, vel* 1i, 1000],
      [pos, vel*-1i, 1000]
    ] #: Array[[Complex, Complex, Integer]]
      .each do|pos2, vel2, score2|
        neighbor = new pos2, vel2
        old_cell = neighbor.cell
        next unless old_cell
        
        score2 += score
        next if old_cell < score2
        
        MAP.fetch(pos2.imag).fetch(pos2.real) #: Hash[Complex, Integer]
          .[]= vel2, score2
        parents[neighbor] << here
        node_set << (
          neighbor #: instance & _Integer
        )
      end
  end
  raise 'finish point unreachable' unless here
  
  node_set.clear
  # Part 2
  count = ->(here) do
    parents[here].each(&count) if node_set.add? here
  end #: ^(instance & _Integer here) -> void
  count.(here)
  puts 'Part 2', node_set.uniq(&:pos).size
end
