module PrivatePlease
  class LineChangeTracker
    class << self
      attr_accessor :prev_prev_self, :prev_self, :curr_self
      @@prev_self = @@curr_self = nil
    end

    MY_TRACE_FUN = lambda do |event, file, line, id, binding, klass|
      return unless 'line'==event
      LineChangeTracker.prev_prev_self = LineChangeTracker.prev_self
      LineChangeTracker.prev_self      = LineChangeTracker.curr_self
      LineChangeTracker.curr_self      = (eval 'self', binding)
      #puts "my : #{event} in #{file}/#{line} id:#{id} klass:#{klass} - self = #{(eval'self', binding).inspect}"
    end

    def self.outside_instance_method_call_detected?(zelf)
      caller_class != zelf.class
    end

    def self.outside_class_method_call_detected?(zelf_class)
      caller_class != zelf_class
    end

  private

    def self.caller_class
      call_initiator = LineChangeTracker.prev_self
      (caller_is_class_method = call_initiator.is_a?(Class)) ?
          call_initiator :
          call_initiator.class
    end
  end
end

set_trace_func(PrivatePlease::LineChangeTracker::MY_TRACE_FUN) #
