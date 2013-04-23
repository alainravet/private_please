# Holds in 2 "buckets" the details (class name + methods names) of the
# methods that are candidate for privatization.
# Those methods were marked via `private_please` in the code.
# Instance methods and class methods are kept separate.

require File.dirname(__FILE__) + '/methods_names_bucket'

module PrivatePlease
  class Store

    class CandidatesDB < Hash
      def initialize
        self[:instance_methods] = MethodsNamesBucket.new
        self[:class_methods   ] = MethodsNamesBucket.new
      end

      # @return [MethodsNamesBucket]
      def instance_methods ; self[:instance_methods] end
      # @return [MethodsNamesBucket]
      def class_methods    ; self[:class_methods   ] end

      def empty?
        instance_methods.empty? && class_methods.empty?
      end

      def store_candidate(candidate)
        cat_key = method_kind(candidate)
        mn_bucket = self[cat_key]
        mn_bucket[candidate.klass_name] ||= Set.new
        mn_bucket[candidate.klass_name].add?  candidate.method_name
      end

      def stored_candidate?(candidate)
        cat_key = method_kind(candidate)
        store_siblings = self[cat_key][candidate.klass_name]
        store_siblings && store_siblings.include?(candidate.method_name)
      end

    private
      def method_kind(candidate)
        candidate.instance_method? ?
            :instance_methods :
            :class_methods
      end
    end
  end
end


