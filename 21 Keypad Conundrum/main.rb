# good o’ Rube Goldberg situation 🪆 ᗡx

# @abstract {#presses}
class KeypadOperator
  def presses(targets) = targets.size
  
  # @abstract {#keypad}, {#route_key}
  class Robot < self
    def keypad = {'A' => 0i}
    def initialize(operator)
      @arm = keypad.fetch('A')
      @presses = Hash.new do|hash, targets| #$ String, Integer, String, Integer
        hash[targets] = targets.each_char.sum { operator.presses route_to it }
      end
    end
    # Assumptions: {@arm} targets `A` both before and after inputting `targets`.
    def presses(targets) = @presses[targets]
    
    # For diagonal routing, prioritizing `>` before `^`/`v` before `<` will avoid ever aiming at a gap.
    ROUTE_RUDL = %w[> ^ v < A].to_h {[ it, 1 ]}
    # @return ordered hashset in the form of a hashmap with void values
    def route_key(target_coords) = ROUTE_RUDL

    def route_to(target)
      target_coords = keypad.fetch target
      assoc_list = route_key target_coords
      dx, dy = (target_coords - @arm).rect #: [Integer, Integer]
      assoc_list['>'], assoc_list['v'] =  dx,  dy
      assoc_list['<'], assoc_list['^'] = -dx, -dy
      @arm = target_coords
      assoc_list.filter_map { _1*_2 if _2.positive? }.join
    end
    
    NUMPAD = (1..9).to_h do|n|
      div, mod = n.divmod(-3)
      [n.to_s, Complex.rect(mod, div)]
    end.merge('A' => 0i, '0' => -1.to_c)
    
    class DPad < self
      KEYPAD = {
        'A' => 0i,
        '^' => -1.to_c,
        'v' => Complex.rect(-1, 1),
        '<' => Complex.rect(-2, 1),
        '>' => 1i
      }.freeze
      def keypad = KEYPAD
    end
    
    numpad = new( # depressurized
      DPad.new( # high levels of radiation
        DPad.new( # -40 degrees
          KeypadOperator.new # full of Historians
        )
      )
    )
    class << numpad
      def keypad = KeypadOperator::Robot::NUMPAD
      # This one’s operated by a robot-operated robot, so we have to prioritize directions by that operator’s expense.
      # `<`s are clearly the most expensive, followed by `v`/`^` for their `<` cost, then finally `>`.
      # Reference: https://www.reddit.com/r/adventofcode/comments/1hj2odw/comment/m6qcv0f/
      ROUTE_LDUR = %w[< v ^ > A].to_h {[ it, 1 ]}
      def route_key(target_coords)
        if (
          @arm.imag.negative? or target_coords.real > -2
        ) and (
          target_coords.imag.negative? or @arm.real > -2
        ) # in the solid region that does not concern the gap
          ROUTE_LDUR
        else
          super
        end
      end
    end
    
    puts ARGF.each_line(chomp: true).sum { numpad.presses(it) * it.to_i }
  end
end
