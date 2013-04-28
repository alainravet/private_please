# As the main program runs, the various method calls are logged here
# (only for the methods marked with `private_please`)

module PrivatePlease
  module Storage

    class CallsStore

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

      def store_outside_call(candidate)
        bucket = candidate.instance_method? ? external_calls : class_external_calls
        bucket.add_method_name(candidate.klass_name, candidate.method_name)
      end

      def store_inside_call(candidate)
        bucket = candidate.instance_method? ? internal_calls : class_internal_calls
        bucket.add_method_name(candidate.klass_name, candidate.method_name)
      end
    end

  end
end
