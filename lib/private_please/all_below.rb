# Usage :
#   class MarkingTest::Automatic2
#     def foo ; end          <---- but not this one.
#     include PrivatePlease::AllBelow  <-- add this line
#
#     def baz ; end          <---- to observe this method
#   protected
#     def self.qux ; end     <---- and this one too
#   end

module PrivatePlease
  module AllBelow
    include PrivatePlease::Extension

    def self.included(base)
      def base.singleton_method_added(method_name)
        #FIXME : don't instrument methods that are already private
        return if [:method_added, :singleton_method_added].include?(method_name)
        candidate = Candidate.for_class_method(klass = self, method_name)
        Instrumentor.instrument_candidate_for_pp_observation(candidate)
      end

      def base.method_added(method_name)
        #FIXME : don't instrument methods that are already private
        candidate = Candidate.for_instance_method(klass = self, method_name)
        Instrumentor.instrument_candidate_for_pp_observation(candidate)
      end
    end

  end
end