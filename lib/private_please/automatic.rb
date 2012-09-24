# Usage :
#   class MarkingTest::Automatic2
#     def foo ; end          <---- but not this one.
#     include PrivatePlease::Automatic  <-- add this line
#
#     def baz ; end          <---- to observe this method
#   protected
#     def qux ; end          <---- and this one too
#   end

module PrivatePlease
  module Automatic
    include PrivatePlease::Extension

    def self.included(base)
      def base.method_added(method_name)
        klass = self
        __instrument_method_for_pp_observation(klass, method_name, check_for_dupe=true)
      end
    end

  end
end