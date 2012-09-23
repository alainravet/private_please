module PrivatePlease

  module Extension

    def private_please(*methods_to_observe)
      klass = self
      methods_to_observe      = methods_to_observe    .collect(&:to_sym)

      # reject invalid methods names
      class_instance_methods  = klass.instance_methods.collect(&:to_sym)
      methods_to_observe.reject! do |m|
        already_defined_instance_method = class_instance_methods.include?(m)
        invalid = !already_defined_instance_method
      end

      methods_to_observe.each do |method_name|
        PrivatePlease.record_candidate(klass, method_name)

        orig_method = instance_method(method_name)

        define_method(method_name) do |*args, &blk|                                   # def observed_method_i(..)
          set_trace_func(nil) #don't track activity while here                        #
                                                                                      #
          if PrivatePlease.active?                                                    #
            LineChangeTracker.outside_call_detected?(self) ?                   #
                PrivatePlease.record_outside_call(self.class, method_name) : #
                PrivatePlease.record_inside_call( self.class, method_name)   #
          end                                                                         #
                                                                                      #
          set_trace_func(LineChangeTracker::MY_TRACE_FUN)                             #
          # make the call :                                                           #
          orig_method.bind(self).call(*args, &blk)                                    #   <call original method>
        end                                                                           # end

      end
    end

  end

end
