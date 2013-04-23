module PrivatePlease
  class Storage

    attr_reader :candidates_by_kind, :internal_calls, :external_calls
    def initialize
      @candidates_by_kind           = {:instance_methods => {}, :class_methods => {}}
      @internal_calls  = Hash.new{ [] }
      @external_calls  = Hash.new{ [] }
    end

    def store_candidate(candidate)
      cat_key = method_kind(candidate)
      candidates_by_kind[cat_key][candidate.klass_name] ||= Set.new
      candidates_by_kind[cat_key][candidate.klass_name].add?  candidate.method_name
    end

    def instance_methods_candidates
      candidates_by_kind[:instance_methods]
    end

    def class_methods_candidates
      candidates_by_kind[:class_methods]
    end

    def stored_candidate?(candidate)
      cat_key = method_kind(candidate)
      store_siblings = candidates_by_kind[cat_key][candidate.klass_name]
      store_siblings && store_siblings.include?(candidate.method_name)
    end

    def record_outside_call(candidate)
      #TODO use a Set instead of an Array
      unless external_calls[candidate.klass_name].include?(candidate.method_name)
        external_calls[candidate.klass_name] += Array(candidate.method_name)
      end
    end

    def record_inside_call(candidate)
      #TODO use a Set instead of an Array
      unless internal_calls[candidate.klass_name].include?(candidate.method_name)
        internal_calls[candidate.klass_name] += Array(candidate.method_name)
      end
    end

  private

    def method_kind(candidate)
      candidate.instance_method? ?
          :instance_methods :
          :class_methods
    end

  end
end