module PrivatePlease ; module Tracking

  module Instrumentor
  class << self

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
        LineChangeTracker::MY_TRACE_FUN.disable  # don't track activity while here
        PrivatePlease::Tracking.after_singleton_method_call(method_name, self_class=self)
        LineChangeTracker::MY_TRACE_FUN.enable                              #
        # make the original call :                                          #
        orig_method.bind(self).call(*args, &blk)                            #   <call original method>
      end                                                                   # end
RUBY
    end


    def add_call_tracking_code_to_instance_method(klass, method_name)
      orig_method = klass.instance_method(method_name)
klass.class_eval <<RUBY
      define_method(method_name) do |*args, &blk|                           # def observed_method_i(..)
        LineChangeTracker::MY_TRACE_FUN.disable #don't track activity while here
        PrivatePlease::Tracking.after_instance_method_call(method_name, self.class)
        LineChangeTracker::MY_TRACE_FUN.enable                              #
        # make the original call :                                          #
        orig_method.bind(self).call(*args, &blk)                            #   <call original method>
      end                                                                   # end
RUBY
    end

  end
  end

end end
