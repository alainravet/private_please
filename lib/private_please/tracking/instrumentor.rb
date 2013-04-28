module PrivatePlease ; module Tracking

  module Instrumentor

    def self.instrument_instance_methods_for_pp_observation(klass, methods_to_observe)
      class_instance_methods = klass.instance_methods.collect(&:to_sym)
      methods_to_observe = methods_to_observe.collect(&:to_sym)
      # reject invalid methods names
      methods_to_observe.reject! do |m|
        already_defined_instance_method = class_instance_methods.include?(m)
        invalid = !already_defined_instance_method
      end

      methods_to_observe.each do |method_name|
        candidate = Candidate.for_instance_method(klass, method_name)
        instrument_candidate_for_pp_observation(candidate) # end
      end
    end


    def self.instrument_candidate_for_pp_observation(candidate)
      return if candidate.already_instrumented?
      PrivatePlease.remember_candidate(candidate)

      klass, method_name = candidate.klass, candidate.method_name
      candidate.instance_method? ?
        instrument_instance_method_with_pp_observation(klass, method_name) :
        instrument_class_method_with_pp_observation(   klass, method_name)
    end



    def self.instrument_class_method_with_pp_observation(klass, method_name)
      orig_method = klass.singleton_class.instance_method(method_name)
klass.class_eval <<RUBY
      define_singleton_method(method_name) do |*args, &blk|                 # def self.observed_method_i(..)
        set_trace_func(nil) #don't track activity while here                #
                                                                            #
        zelf_class=self                                                     #
        candidate = PrivatePlease::Candidate.for_class_method(zelf_class, method_name)
        PrivatePlease.after_method_call(candidate, LineChangeTracker.outside_class_method_call_detected?(zelf_class))
                                                                            #
        set_trace_func(LineChangeTracker::MY_TRACE_FUN)                     #
        # make the call :                                                   #
        orig_method.bind(self).call(*args, &blk)                            #   <call original method>
      end                                                                   # end
RUBY
    end
    private_class_method :instrument_class_method_with_pp_observation


    def self.instrument_instance_method_with_pp_observation(klass, method_name)
      orig_method = klass.instance_method(method_name)
klass.class_eval <<RUBY
      define_method(method_name) do |*args, &blk|                           # def observed_method_i(..)
        set_trace_func(nil) #don't track activity while here                #
                                                                            #
        candidate = PrivatePlease::Candidate.for_instance_method(self.class, method_name)
        PrivatePlease.after_method_call(candidate, LineChangeTracker.outside_instance_method_call_detected?(self))                  #
                                                                            #
        set_trace_func(LineChangeTracker::MY_TRACE_FUN)                     #
        # make the call :                                                   #
        orig_method.bind(self).call(*args, &blk)                            #   <call original method>
      end                                                                   # end
RUBY
    end
    private_class_method :instrument_instance_method_with_pp_observation

  end

end end