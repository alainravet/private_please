# As the main program runs, the various method calls are logged here
# (only for the methods marked with `private_please`)

module PrivatePlease
  module Storage

    class CallsLog

      def initialize
        @internal_calls       = MethodsNamesBucket.new
        @external_calls       = MethodsNamesBucket.new
        @class_internal_calls = MethodsNamesBucket.new
        @class_external_calls = MethodsNamesBucket.new
      end

    #--------------------------------------------------------------------------
    # QUERIES:
    #--------------------------------------------------------------------------

      attr_reader :internal_calls,
                  :external_calls,
                  :class_internal_calls,
                  :class_external_calls

    #--------------------------------------------------------------------------
    # COMMANDS:
    #--------------------------------------------------------------------------

      def record_outside_call(candidate)
        candidate.instance_method? ?
          external_calls[      candidate.klass_name].add(candidate.method_name) :
          class_external_calls[candidate.klass_name].add(candidate.method_name)
      end

      def record_inside_call(candidate)
        candidate.instance_method? ?
          internal_calls[      candidate.klass_name].add(candidate.method_name) :
          class_internal_calls[candidate.klass_name].add(candidate.method_name)
      end
    end

  end
end
