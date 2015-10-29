class SourceView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
  end

  def draw
    @text = div
    @ticker = div
    @element = div(".source_view") << div("h4.source" , "Class.Method") << @ticker << @text
    @element
  end

  def instruction_changed
    i = @interpreter.instruction
    return "" unless i
    if( i.is_a?(Register::Label) and i.name.include?("."))
      @element.at_css(".source").text = i.name
    end
    case i.source
    when AST::Node
      update_code
      @ticker.text = ""
    when String
      @ticker.text = i.source
    else
      raise i.source.class.name
    end
  end
  def update_code
    @text.inner_html = ToCode.new.process( @interpreter.instruction.source)
  end
end
class ToCode <   AST::Processor

  def handler_missing s
    puts "Missing: " + s.type
    s.to_sexp
  end
  def on_string s
    "'" + s.first + "'"
  end
  def on_field_def statement
    type , name , value = *statement
    str = type + " " + name
    str += " = #{process(value)}" if value
    str
  end
  def on_return statement
  "return "  + process(statement.first ) + "<br>"
  end
  def on_false_statements s
    on_statements s
  end
  def on_true_statements s
    on_statements s
  end
  def on_statements s
    str = ""
    s.children.each do |c|
      str += process(c).to_s
      str +=  "<br>"
    end
    str
  end
  def on_if_statement statement
    branch_type , condition , if_true , if_false = *statement
    condition = condition.first
    ret = "if_#{branch_type}(" + process(condition) + ")<br>" + process(if_true)
    ret += "else" + "<br>" +  process(if_false)  if if_false
    ret += "end" + "<br>"
  end
  def on_assignment statement
    name , value = *statement
    name = name.to_a.first
    v = process(value)
    name + " = " + v
  end
  def on_call c
    name , arguments , receiver = *c
    ret = process(name)
    ret = process(receiver.first) + "." + ret if receiver
    ret += "("
    ret  += process(arguments).join(",")
    ret += ")"
  end
  def on_operator_value statement
    operator , left_e , right_e = *statement
    left_reg = process(left_e)
    right_reg = process(right_e)
    left_reg + " " + operator + " " + right_reg
  end
  def on_arguments args
    args.children.collect{|c| process(c)}
  end
  def on_name name
    name.first
  end
  def on_int i
    i.first.to_s
  end
end
