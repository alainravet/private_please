# Usage :
#   class MarkingTest::Automatic2
#     def foo ; end          <---- but not this one.
#     include PrivatePlease::Tracking::InstrumentsAllBelow  <-- add this line
#
#     def baz ; end          <---- to observe this method
#   protected
#     def self.qux ; end     <---- and this one too
#   end

module PrivatePlease ; module Tracking

  module InstrumentsAllBelow
    include PrivatePlease::Tracking::Extension

    def self.included(base)

      def base.singleton_method_added(method_name)
        return if [:method_added, :singleton_method_added].include?(method_name)
        return if [:included].include?(method_name) && !self.is_a?(Class)

        is_private_class_method = singleton_class.private_method_defined?(method_name)
        return if is_private_class_method

        candidate = Candidate.for_class_method(klass = self, method_name)
        Tracking::Instrumentor.instrument_candidate_for_pp_observation(candidate)
      end


      def base.method_added(method_name)
        is_private_instance_method = self.private_method_defined?(method_name)
        return if is_private_instance_method

        candidate = Candidate.for_instance_method(klass = self, method_name)
        Tracking::Instrumentor.instrument_candidate_for_pp_observation(candidate)
      end
    end

  end

end end