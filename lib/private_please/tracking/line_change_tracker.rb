module PrivatePlease ; module Tracking

  class LineChangeTracker
    class << self

      attr_accessor :prev_prev_self, :prev_self, :curr_self
      @@prev_self = @@curr_self = nil

      alias :call_initiator :prev_self

      def reset
        prev_prev_self = prev_self = curr_self = nil
      end
    end

    MY_TRACE_FUN = TracePoint.new(:line) do |tp|
      LineChangeTracker.prev_prev_self = LineChangeTracker.prev_self
      LineChangeTracker.prev_self      = LineChangeTracker.curr_self
      LineChangeTracker.curr_self      = tp.self
    end
  end

end end
