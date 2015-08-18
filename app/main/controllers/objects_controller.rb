if RUBY_PLATFORM == 'opal'
  require "native"
end

module Main
  class ObjectsController < Volt::ModelController

    def index_ready
      container = Native(self.container).querySelector("ul")
      return unless container
      puts "li " + container.innerHTML + " lo"
#      red = -> (event) {  container.style.backgroundColor = "red" }
      red = -> (event) {  puts container.tagName }
      container.addEventListener("mouseenter" , red)
    end

    def marker id
      var = Virtual.machine.objects[id]
      if var.is_a? String
        str "Wo"
      else
        str = var.class.name.split("::").last[0,2]
      end
      str + " : #{id.to_s}"
    end

    def content(id)
      object = Virtual.machine.objects[id]
      fields = []
      if object and ! object.is_a?(String)
        clazz = object.class.name.split("::").last
        fields << ["#{clazz}:#{object.object_id}" , 0]
        fields << ["--------------------" ,  0 ]
        object.get_instance_variables.each do |variable|
          f = object.get_instance_variable(variable)
          fields << ["#{variable} : #{marker(f.object_id)}" , f.object_id]
        end
      end
      fields
    end

    def is_object?( id )
      Virtual.machine.objects[id] != nil
    end

  end
end
