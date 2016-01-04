module PrivatePlease
  module Storage
    class CalledMethodsMemoryStore
      attr_reader :public_calls, :private_calls

      def initialize
        @public_calls  = Set.new
        @private_calls = Set.new
      end

      def add_public_call(value)
        @public_calls .add value
      end

      def add_private_call(value)
        @private_calls.add value
      end
    end
  end
end
