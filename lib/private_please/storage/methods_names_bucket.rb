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

      def clone
        (self.class).new.tap do |klone|
          classes_names.each do |class_name|
            klone.set_methods_names(class_name, (self).get_methods_names(class_name))
          end
        end
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

      def remove(other)
        other.classes_names.each do |cn|
          next if (methods_to_remove = other.get_methods_names(cn)).empty?
          next if (methods_before    = self .get_methods_names(cn)).empty?
          difference = methods_before - methods_to_remove
          self.set_methods_names(cn, difference)
        end
        prune!
        self
      end

    private

      def prune!
        self.reject!{|_, v|v.empty?}
      end
    end

  end
end