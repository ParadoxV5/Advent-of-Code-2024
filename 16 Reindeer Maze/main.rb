# Good o’ Maze Solving!
# Note that the best path is not necessarily the shortest path – a direct but
# zigzagging diagonal is worse than a large detour with only a couple of turns.
# With a map much narrower than 1000÷4 = 250, it should the path with the fewest
# turns, though those are relatively harder to minimize than Taxicab Distance.

QueuedNode = Data.define :pos, :vel
class QueuedNode
  # This does not contain nodes currently having infinite distance – the map tracks ’em.
  frontier = Set.new #$ QueuedNode & _Integer
  finish = 0i
  
  # Don’t need a trailing `\n` because the maze is fully closed.
  MAP = ARGF.each_line(chomp: true).with_index.map do|line, y|
    line.each_char.with_index.map do|cell, x|
      case cell
      when '#'
        next
      when 'S'
        frontier << (
          new(Complex.rect(x, y), 1.to_c) #: QueuedNode & _Integer
        )
        next 0
      when 'E'
        finish = Complex.rect x, y
      end
      Float::INFINITY
    end
  end
  
  def cell = MAP.fetch(pos.imag)[pos.real]
  
  # Dijkstra’s implemented as a maze solver (i.e., hybrid with BFS)
  while (here = frontier.min_by(&:cell))
    score = here.cell
    break puts score if here.pos.eql? finish
    frontier.delete here
    
    vel = here.vel
    [vel, vel*1i, vel*-1i].each do|vel2|
      pos2 = here.pos + vel2
      neighbor = new pos2, vel2
      
      old_cell = neighbor.cell
      next unless old_cell
      
      score2 = score + (vel.equal?(vel2) ? 1 : 1001)
      next if old_cell <= score2
      
      MAP.fetch(pos2.imag)[pos2.real] = score2
      frontier << (
        neighbor #: QueuedNode & _Integer
      )
    end
  end
end
