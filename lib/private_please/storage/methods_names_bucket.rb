# Associates and indexes classes (name) and some of their methods (names).
# Ex:
#   +-------------+---------------------------------------+
#   | class name  => 1+ methods names                     |
#   +-------------+---------------------------------------+
#   |    'Foo'    | MethodsNames.new('foo to_baz to_bar') |
#   |    'Bar'    | MethodsNames.new('qux')               |
#   +-------------+---------------------------------------+

module PrivatePlease
  module Storage

    class MethodsNamesBucket < Hash

      def initialize
        super{|hash, class_name|
          #hash[class_name] = PrivatePlease::Storage::MethodsNames.new
          hash.set_methods_names(class_name, MethodsNames.new)
        }
      end

    #--------------------------------------------------------------------------
    # QUERIES:
    #--------------------------------------------------------------------------

      alias_method :classes_names,     :keys
      alias_method :get_methods_names, :[]
      undef :[], :keys

    #--------------------------------------------------------------------------
    # COMMANDS:
    #--------------------------------------------------------------------------

      alias_method :set_methods_names, :[]=
      undef :[]=

      def add_method_name(class_name, method_name)
        self.get_methods_names(class_name).add(method_name)
      end

    end

  end
end