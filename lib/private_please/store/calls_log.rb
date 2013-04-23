# As the main program runs, the various method calls are logged here
# (only for the methods marked with `private_please`)

module PrivatePlease
  class Store

    class CallsLog
      attr_reader :internal_calls, :external_calls

      def initialize
        @internal_calls  = Hash.new{ [] } #TODO use a Set instead of an Array
        @external_calls  = Hash.new{ [] } #TODO use a Set instead of an Array
      end

      def record_outside_call(candidate)
        unless external_calls[candidate.klass_name].include?(candidate.method_name)
          external_calls[candidate.klass_name] += Array(candidate.method_name)
        end
      end

      def record_inside_call(candidate)
        unless internal_calls[candidate.klass_name].include?(candidate.method_name)
          internal_calls[candidate.klass_name] += Array(candidate.method_name)
        end
      end
    end

  end
end
