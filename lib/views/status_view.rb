class StatusView < ElementView

  def initialize interpreter
    @interpreter = interpreter
  end

  def draw
    @element = div(".status_view") <<
    div("h4" , "Interpreter" ) <<
      div("button.act" , "Next") <<
      div( "br") <<
      div("span.clock" , clock_text) <<
      div( "br") <<
      div("span.state" ,  state_text) <<
      div( "br")  <<
      div( "span.link" , link_text) <<
      div( "br" , "Stdout") <<
      div("span.stdout")
    # set up event handler
    @element.at_css(".act").on("click") { self.update }
    return @element
  end

  def update
    begin
      @interpreter.tick
    rescue => e
      puts e
    end
    @element.at_css(".clock").text = clock_text
    @element.at_css(".link").text = link_text
    @element.at_css(".state").text = state_text
    @element.at_css(".stdout").text = @interpreter.stdout
  end

  def link_text
    "Link #{@interpreter.link}"
  end

  def state_text
    "State #{@interpreter.state}"
  end

  def clock_text
    "Instruction #{@interpreter.clock}"
  end
end
