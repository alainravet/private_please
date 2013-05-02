module PrivatePlease::Tracking

  module Utils
    class << self

      def private_instance_method?(klass, method_name)
        klass.private_method_defined?(method_name)
      end

      def private_singleton_method?(klass, method_name)
        klass.singleton_class.private_method_defined?(method_name)
      end

      def instance_method_defined_by_ancestor?(klass, method_name)
        ancestor_of(klass).any? do |a|
          a.method_defined?(method_name) || a.private_method_defined?(method_name)
        end
      end

      def singleton_method_defined_by_ancestor?(klass, method_name)
        ancestor_of(klass).any? do |a|
          a.singleton_class.method_defined?(method_name) || a.singleton_class.private_method_defined?(method_name)
        end
      end

    private
      def ancestor_of(klass)
        klass.ancestors - [klass]
      end

    end
  end

end