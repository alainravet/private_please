module PrivatePlease

  module Extension

    def private_please(*methods_to_observe)
      parameterless_call = methods_to_observe.empty?
      klass = self

      if parameterless_call
        klass.send :include, PrivatePlease::Automatic

      else
        class_instance_methods  = klass.instance_methods.collect(&:to_sym)
        methods_to_observe      = methods_to_observe    .collect(&:to_sym)
        # reject invalid methods names
        methods_to_observe.reject! do |m|
          already_defined_instance_method = class_instance_methods.include?(m)
          invalid = !already_defined_instance_method
        end

        methods_to_observe.each do |method_name|
          __instrument_method_for_pp_observation(klass, method_name) # end
        end
      end
    end


    def __instrument_method_for_pp_observation(klass, method_name, check_for_dupe=false)
      if check_for_dupe
        return if PrivatePlease.already_instrumented?(klass, method_name)
      end
      PrivatePlease.record_candidate(klass, method_name)

      orig_method = instance_method(method_name)

      define_method(method_name) do |*args, &blk|                           # def observed_method_i(..)
        set_trace_func(nil) #don't track activity while here                #
                                                                            #
        if PrivatePlease.active?                                            #
          LineChangeTracker.outside_call_detected?(self) ?                  #
              PrivatePlease.record_outside_call(self.class, method_name) :  #
              PrivatePlease.record_inside_call(self.class, method_name)     #
        end                                                                 #
                                                                            #
        set_trace_func(LineChangeTracker::MY_TRACE_FUN)                     #
        # make the call :                                                   #
        orig_method.bind(self).call(*args, &blk)                            #   <call original method>
      end                                                                   # end
    end

  end

end
