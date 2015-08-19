
class RegisterView

  @@register_names = (0..8).collect {|i| "r#{i}"}

  def initialize at_y
    super()
    @registers = {}
    x = 0
    @@register_names.each do |name|
      reg = Text.new( name )
      reg.position = Point.new x  , at_y
      x += reg.width + 20
      @registers[name] = reg
      self.add_child reg
    end
    def draw_me

    end
  end
end