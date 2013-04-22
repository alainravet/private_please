# Usage :
#   class MarkingTest::Automatic2
#     def foo ; end          <---- but not this one.
#     include PrivatePlease::AllBelow  <-- add this line
#
#     def baz ; end          <---- to observe this method
#   protected
#     def qux ; end          <---- and this one too
#   end

module PrivatePlease
  module AllBelow
    include PrivatePlease::Extension

    #TODO : support class methods

    def self.included(base)
      def base.method_added(method_name)
        klass = self
        candidate = Candidate.for_instance_method(klass, method_name)
        Instrumentor.instrument_candidate_for_pp_observation(candidate, check_for_dupe=true)
      end
    end

  end
end