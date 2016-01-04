require 'private_please/tracking/method_details'

module PrivatePlease
  module Tracking
    class Result
      def initialize(encountered_method_calls)
        @private_calls = encountered_method_calls.private_calls
        @public_calls = encountered_method_calls.public_calls
      end

      def public_methods_only_called_privately
        @private_calls - @public_calls
      end

      def to_two_level_hash
        two_level_hash = Hash.new { |h, k| h[k] = {} }
        public_methods_only_called_privately.each do |class_plus_method|
          md = MethodDetails.from_class_plus_method(class_plus_method)
          two_level_hash[md.klass][md.separator_plus_method] = [md.source_path, md.lineno]
        end
        two_level_hash.delete_if { |_k, v| v.empty? }
      end
    end
  end
end
