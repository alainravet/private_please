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

    def self.outside_call_detected?(zelf)
      call_initiator = LineChangeTracker.prev_self
      call_initiator.class != zelf.class
    end

  end
end

set_trace_func(PrivatePlease::LineChangeTracker::MY_TRACE_FUN)