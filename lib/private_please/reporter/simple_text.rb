require File.dirname(__FILE__) + '/base'
require 'erb'
require File.dirname(__FILE__) + '/helpers/options_helpers'
require File.dirname(__FILE__) + '/helpers/text_table_helpers'
module  PrivatePlease ; module Reporter

  class SimpleText < Base

    TEMPLATE_PATH     = File.expand_path(File.dirname(__FILE__) + '/templates/simple.txt.erb')

    def text
      erb = ERB.new(File.read(TEMPLATE_PATH), 0,  "%<>")
      erb.result(binding)
    end

  end

end end