module PrivatePlease
  module Reporting
    class SimpleText
      def initialize(result)
        @result = result
      end

      def text
        compiled_data = compile_data  # passed to ERB via 'binding'
        erb = ERB.new(File.read(template), 0,  '%<>')
        erb.result(binding)
      end

      #-----------------------------------------------------------------------------
      private

      def template
        templates_home = File.expand_path(File.dirname(__FILE__) + '/templates')
        "#{templates_home}/simple.txt.erb"
      end

      # Output example:
      # [
      #   ["/tmp/project/foo/simple_text_foo.rb",
      #     [[18, "SimpleTextFoo#public_i_2"],
      #      [11, "SimpleTextFoo.public_c_2"]
      #     ]
      #   ]
      #   ...
      # ]
      def compile_data
        res = Hash.new { |h, k| h[k] = [] }
        @result.to_two_level_hash.each do |klass, methods_and_locations|
          methods_and_locations.each_pair do |meth, locations|
            source, lineno = locations
            res[source] << [lineno, "#{klass}#{meth}"]
          end
        end
        res.sort    # by source file path
      end
    end
  end
end
