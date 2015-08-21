class ValueView < ElementView

  def initialize  value
    @value = value
  end

  def draw
    DOM do |dom|
      dom.ul.nav! do
        dom.li do
          dom.a( :href => "#" ) { @value }
        end
      end
    end
  end
end
