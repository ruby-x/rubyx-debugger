require_relative "object_view"
require_relative "value_view"

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

  def root
    "div.registers_view"
  end

  def draw
    list = super()
    list = list.children.each do |reg|
      elem = create_element("div.register_view")
      wrap_node_with reg , elem
    end
    @container_element
  end

  def register_changed reg , old , value
    reg = reg.symbol unless reg.is_a? Symbol
    return unless reg == register
    objects_id! value
    calc_fields
  end

  def calc_fields
    #puts "My id #{objects_id} , #{objects_id.class}"
    object = Virtual.machine.objects[value]
    self.fields.clear
    if object and ! object.is_a?(String)
      clazz = object.class.name.split("::").last
      #puts "found #{clazz}"
      self.fields << "#{clazz}:#{object.internal_object_length}"
      self.fields << object.get_layout
      object.get_instance_variables.each do |variable|
        f = object.get_instance_variable(variable)
        self.fields << f
      end
    end
  end

end
