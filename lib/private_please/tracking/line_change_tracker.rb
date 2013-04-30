module PrivatePlease ; module Tracking

  class LineChangeTracker
    class << self

      attr_accessor :prev_prev_self, :prev_self, :curr_self
      @@prev_self = @@curr_self = nil

      alias :call_initiator :prev_self 
    end

    MY_TRACE_FUN = lambda do |event, file, line, id, binding, klass|
      return unless 'line'==event
      LineChangeTracker.prev_prev_self = LineChangeTracker.prev_self
      LineChangeTracker.prev_self      = LineChangeTracker.curr_self
      LineChangeTracker.curr_self      = (eval 'self', binding)
      #puts "my : #{event} in #{file}/#{line} id:#{id} klass:#{klass} - self = #{(eval'self', binding).inspect}"
    end

  end

end end