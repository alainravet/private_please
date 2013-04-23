# As the main program runs, the various method calls are logged here
# (only for the methods marked with `private_please`)

module PrivatePlease
  class Store

    class CallsLog
      attr_reader :internal_calls, :external_calls

      def initialize
        @internal_calls   = Hash.new{|hash, klass_name| hash[klass_name] = MethodsNames.new}
        @external_calls   = Hash.new{|hash, klass_name| hash[klass_name] = MethodsNames.new}
      end

      def record_outside_call(candidate)
        external_calls[candidate.klass_name].add candidate.method_name
      end

      def record_inside_call(candidate)
        internal_calls[candidate.klass_name].add candidate.method_name
      end
    end

  end
end
