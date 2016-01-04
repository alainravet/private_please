module PrivatePlease
  module Tracking
    class TracePointDetails < Struct.new(:event, :object_id, :path, :lineno, :defined_class, :method_id, :_self)
      def self.from(tp)
        new(tp.event, tp.self.object_id, tp.path, tp.lineno, tp.defined_class, tp.method_id, tp.self)
      end

      def same_object?(other)
        object_id == other.object_id
      end

      def code
        @_code ||= File.readlines(path)[lineno - 1].chomp
      end

      # Combine the class and method name with the proper separator
      # Examples:
      #  Array#new
      #  Array.size
      def method_full_name
        if module_method?
          instance_method = defined_class.instance_methods.include?(method_id)
          instance_method ?
            "#{defined_class}##{method_id}" :
            "#{defined_class}.#{method_id}"
        else
          instance_method = !(_self.class == Class)
          instance_method ?
              "#{defined_class}##{method_id}" :
              "#{_self}.#{method_id}"
        end
      end

      private

      def module_method?
        defined_class.instance_of?(Module)
      end
    end
  end
end
