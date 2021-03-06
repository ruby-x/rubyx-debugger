require_relative "object_view"

class RegistersView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:register_changed,  self)
    kids = []
    @interpreter.registers.each do |reg , val|
      kids << ValueView.new( val )
    end
    super(kids)
  end

  def draw
    super( "div.registers_view" )
    @element.children.each_with_index do |reg, index|
      elem = div("div.register_view")
      wrap_node_with reg , elem
    end
    @element
  end

  def register_changed( reg , old , value )
    reg = reg.symbol unless reg.is_a? Symbol
    index = reg.to_s[1 .. -1 ].to_i
    has = Risc::Position.set?(value)
    if( has )
      if has.object.is_a?(Risc::Label)
        swap = ValueView.new "Label: #{has.object.name}"
      else
        swap =  ObjectView.new( value , @interpreter , 16 - index )
      end
    else
      swap = ValueView.new value
    end
    replace_at index , swap
#    @elements[index].style["z-index"] = -index
  end

end

class ValueView < ElementView

  def initialize  value
    @value = value
  end

  def draw
    li = div("li")
    li << div("span",  @value)
    @element = div("ul.nav!") << li
  end
end
