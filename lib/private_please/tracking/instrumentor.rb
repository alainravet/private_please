module PrivatePlease ; module Tracking
  module Instrumentor
  class << self

    def instrument_instance_methods_for_pp_observation(klass, methods_to_observe)
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

    def add_call_tracking_code_to(candidate)
      return if candidate.already_instrumented?
      candidate.mark_as_instrumented

      klass, method_name = candidate.klass, candidate.method_name
      candidate.instance_method? ?
        add_call_tracking_code_to_instance_method(klass, method_name) :
        add_call_tracking_code_to_class_method(   klass, method_name)
    end


  private

    def add_call_tracking_code_to_class_method(klass, method_name)
      orig_method = klass.singleton_class.instance_method(method_name)
klass.class_eval <<RUBY
      define_singleton_method(method_name) do |*args, &blk|                 # def self.observed_method_i(..)
        set_trace_func(nil) #don't track activity while here                #
        PrivatePlease::Tracking.after_singleton_method_call(method_name, self_class=self)
        set_trace_func(LineChangeTracker::MY_TRACE_FUN)                     #
        # make the original call :                                          #
        orig_method.bind(self).call(*args, &blk)                            #   <call original method>
      end                                                                   # end
RUBY
    end


    def add_call_tracking_code_to_instance_method(klass, method_name)
      orig_method = klass.instance_method(method_name)
klass.class_eval <<RUBY
      define_method(method_name) do |*args, &blk|                           # def observed_method_i(..)
        set_trace_func(nil) #don't track activity while here                #
        PrivatePlease::Tracking.after_instance_method_call(method_name, self.class)
        set_trace_func(LineChangeTracker::MY_TRACE_FUN)                     #
        # make the original call :                                          #
        orig_method.bind(self).call(*args, &blk)                            #   <call original method>
      end                                                                   # end
RUBY
    end

  end
  end

end end
