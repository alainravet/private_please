require File.dirname(__FILE__) + '/base'
require 'erb'
require File.dirname(__FILE__) + '/helpers/options_helpers'
require File.dirname(__FILE__) + '/helpers/text_table_helpers'
module  PrivatePlease ; module Reporter

  class SimpleText < Base

    def text
      template  = compact_mode? ?
          "#{TEMPLATE_HOME}/compact.txt.erb" :
          "#{TEMPLATE_HOME}/simple.txt.erb"
      erb       = ERB.new(File.read(template), 0,  "%<>")
      erb.result(binding)
    end

  #-----------------------------------------------------------------------------
  private

    TEMPLATE_HOME     = File.expand_path(File.dirname(__FILE__) + '/templates')

    def compact_mode?
      options.only_show_good_candidates?
    end
  end

end end
