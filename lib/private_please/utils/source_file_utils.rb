module PrivatePlease
  module Utils
    module SourceFileUtils
      module_function

      def source_path_and_lineno(klass, separator, method)
        is_instance_method = separator == '#'
        if klass.instance_of?(Module)
          if is_instance_method
            klass.instance_method(method).source_location
          else
            klass.singleton_method(method).source_location
          end


        else
          is_instance_method ?
              klass.instance_method(method).source_location :
              klass.method(method).source_location
        end
      end
    end
  end
end
