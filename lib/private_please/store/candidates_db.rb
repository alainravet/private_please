# Holds in 2 "buckets" the details (class name + methods names) of the
# methods that are candidate for privatization.
# Those methods were marked via `private_please` in the code.
# Instance methods and class methods are kept separate.

require File.dirname(__FILE__) + '/methods_names_bucket'

module PrivatePlease
  class Store

    class CandidatesDB

      def initialize
        @instance_methods = MethodsNamesBucket.new
        @class_methods    = MethodsNamesBucket.new
      end

    #--------------------------------------------------------------------------
    # QUERIES:
    #--------------------------------------------------------------------------

      attr_reader :instance_methods,
                  :class_methods

      def empty?
        instance_methods.empty? && class_methods.empty?
      end

      def stored_candidate?(candidate)
        bucket_for(candidate)[candidate.klass_name].include?(candidate.method_name)
      end

    #--------------------------------------------------------------------------
    # COMMANDS:
    #--------------------------------------------------------------------------

      def store_candidate(candidate)
        bucket_for(candidate)[candidate.klass_name].add? candidate.method_name
      end

    #--------------------------------------------------------------------------
    private

      def bucket_for(candidate)
        candidate.instance_method? ? @instance_methods : @class_methods
      end

    end
  end
end
