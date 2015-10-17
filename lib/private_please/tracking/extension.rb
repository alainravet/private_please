module PrivatePlease ; module Tracking

  module Extension

    def private_please
      include PrivatePlease::Tracking::InstrumentsAllMethodsBelow
      PrivatePlease::Tracking::LineChangeTracker::MY_TRACE_FUN.enable
    end

  end

end end
