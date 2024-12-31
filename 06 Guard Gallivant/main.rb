# There isn‘t a better strategy than brute-force checking every cell in Part
# 1’s path to see if obstructing it would redirect the guard into a loop.

# Peeking at others’ solutions – many simply iterate Part 1’s result set of unique positions.
# (There are even brute-forcers who try every position on the map, including ones the guard never reaches in Part 1.)
# This requires the puzzle constraint of only placing the new obstacle on time 0,
# because for positions that the guard passes more than once in Part 1,
# it otherwise may be possible to form a loop by placing the obstacle not before,
# but inbetween the first and last time the guard reaches the position.
# The puzzle only implies this constraint by stating that:
# 
# > The new obstruction can't be placed at the guard's starting position -
# > the guard is there right now and would notice.


# Abstract base class – polymorphism makes the code look prettier
class Simulator
  # Unique IDs allow Part 2 sub-simulations to trace on the same {MAP} without affecting one another.
  # ```rbs
  # type simulation = Integer
  # type unvisited  = '.'
  # type obstacle   = '#'
  # type oob        = "\n"?
  # ```
  MAP = ARGF.map(&:chars) << []
  
  class << self
    # @abstract action to take before stepping forward
    # @note triggers before {#before_step_in_new_dir}
    def before_step(pos, vel, pos2)
    end
    # @abstract action to take before stepping forward after turning
    # @note triggers after {#before_step}
    def before_step_in_new_dir(pos, simulation_id)
      MAP.fetch(pos.imag)[pos.real] = simulation_id # mark turning for loop detection
    end
    
    # Based on `main1.rb`’s main loop
    # @note raise {StopIteration} to terminate early
    def call(pos, vel, simulation_id)
      turned = false
      loop do
        pos2 = pos + vel
        case MAP.fetch(pos2.imag)[pos2.real]
        when '#'
          vel *= 1i # +Y is down!
          turned = true
          redo
        when "\n", nil
          return
        end
        
        before_step(pos, vel, pos2)
        if turned
          before_step_in_new_dir(pos, simulation_id)
          turned = false
        end
        pos = pos2 # step forward
      end
    end
  end
  
  
  class Part2 < self
    singleton_class.attr_reader :count
    @count = 0
    
    # loop detected if we’re turning at a place where we’ve turned before during either Part 1 or Part 2
    # (We don’t use a set because we can instead inline that memory into {MAP})
    def self.before_step_in_new_dir(pos, simulation_id)
      if MAP.fetch(pos.imag)[pos.real] in ^(simulation_id) | 0
        @count += 1
        raise StopIteration
      end
      super
    end
  end
  
  class Part1 < self
    # still track Part 1, because Pitfall: Do not simuate obstacle on previously simulated `pos2`
    VISITED = Set.new
    def self.call(pos, ...)
      VISITED << pos # “[…] the guard is there right now and would notice.”
      super
    end
    def self.before_step(pos, vel, pos2)
      if VISITED.add? pos2
        MAP.fetch(pos2.imag)[pos2.real] = '#' # temporarily plop an ‘O’ disguised as an ‘#’
        Part2.(pos, vel, Part1::VISITED.size)
        MAP.fetch(pos2.imag)[pos2.real] = '.' # revert
      end
    end
  end
  
  
  MAP.each_with_index do|row, y|
    if (x = row.index '^')
      row[x] = '.' # Remove this char from the charset
      Part1.(Complex.rect(x, y), -1i, 0)
      
      puts(
        'Part 1',
        Part1::VISITED.size,
        'Part 2',
        Part2.count
      )
      exit
    end
  end
end
