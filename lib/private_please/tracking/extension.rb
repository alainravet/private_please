module PrivatePlease ; module Tracking

  module Extension

    def private_please
      include PrivatePlease::Tracking::InstrumentsAllMethodsBelow
      set_trace_func PrivatePlease::Tracking::LineChangeTracker::MY_TRACE_FUN
    end

  end

end end
