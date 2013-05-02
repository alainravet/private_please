# Usage :
#   class MarkingTest::Automatic2
#     def foo ; end          <---- but not this one.
#     include PrivatePlease::Tracking::InstrumentsAllMethodsBelow  <-- add this line
#
#     def baz ; end          <---- to observe this method
#   protected
#     def self.qux ; end     <---- and this one too
#   end

module PrivatePlease ; module Tracking

  module InstrumentsAllMethodsBelow
    include PrivatePlease::Tracking::Extension

    def self.included(base)

      def base.singleton_method_added(method_name)
        return if Utils.private_singleton_method?(self, method_name) \
               || Utils.singleton_method_defined_by_ancestor?(self, method_name)

        candidate = Candidate.for_class_method(klass = self, method_name)
        Instrumentor.add_call_tracking_code_to(candidate)
      end


      def base.method_added(method_name)
        return if Utils.private_instance_method?(self, method_name) \
               || Utils.instance_method_defined_by_ancestor?(self, method_name)

        candidate = Candidate.for_instance_method(klass = self, method_name)
        Instrumentor.add_call_tracking_code_to(candidate)
      end
    end

  end

end end