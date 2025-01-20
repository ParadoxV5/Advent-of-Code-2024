# Fetch–Execute! I’m down.

# @abstract {#call}
class Instruction
  singleton_class.attr_accessor :pc, :a, :b, :c, :rom, :out
  self.pc = 0
  self.out = []
  
  def self.get_combo(operand) = case operand
    when 4 then a
    when 5 then b
    when 6 then c
    when 7 then raise NotImplementedError
    else operand
  end
  def get_combo(...) = Instruction.get_combo(...)
  
  def call(operand)
    Instruction.pc += 2
  end
  alias initialize instance_eval
  
  # @abstract {#call}
  class DV < self
    def call(operand)
      super
      Instruction.a >> get_combo(operand) # n >> d = n / 2^d
    end
  end
  class BXL < self
    def call(operand)
      super
      Instruction.b ^= operand
    end
  end
  # @abstract {#call}
  class ST < self
    def call(operand)
      super
      get_combo(operand) & 0b111
    end
  end
  
  INSTRUCTIONS = [
    # 0: adv
    DV.new { def call(...) = Instruction.a = super }, # steep:ignore UnexpectedSuper
    # 1: bxl
    BXL.new {},
    # 2: bst
    ST.new { def call(...) = Instruction.b = super }, # steep:ignore UnexpectedSuper
    # 3: jnz
    new { def call(operand)
      if Instruction.a.zero?
        super # steep:ignore UnexpectedSuper
      else
        Instruction.pc = operand
      end
    end },
    # 4: bxc
    BXL.new { def call(...) = Instruction.b = super(Instruction.c) }, # steep:ignore UnexpectedSuper
    # 5: out
    ST.new { def call(...)
      operand = super # steep:ignore UnexpectedSuper
      Instruction.out << operand
      operand
    end },
    # 6: bdv
    DV.new { def call(...) = Instruction.b = super }, # steep:ignore UnexpectedSuper
    # 7: cdv
    DV.new { def call(...) = Instruction.c = super }  # steep:ignore UnexpectedSuper
  ]
  
  self.a, self.b, self.c, *self.rom = ARGF.read #: String
    .scan(/\d++/) #: Array[String]
    .map(&:to_i) #:[Integer, Integer, Integer, Integer] # this assertion fixes Steep
  while (opcode = rom[pc])
    INSTRUCTIONS.fetch(opcode).(rom.fetch(pc.succ))
  end
  puts out.join ','
end
