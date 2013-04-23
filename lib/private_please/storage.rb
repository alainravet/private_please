module PrivatePlease
  class Storage

    attr_reader :candidates_plus, :inside_called_candidates, :outside_called_candidates
    def initialize
      @candidates_plus           = {:instance_methods => {}, :class_methods => {}}
      @inside_called_candidates  = Hash.new{ [] }
      @outside_called_candidates = Hash.new{ [] }
    end

    def store_candidate(candidate)
      cat_key = method_kind(candidate)
      candidates_plus[cat_key][candidate.klass_name] ||= Set.new
      candidates_plus[cat_key][candidate.klass_name].add?  candidate.method_name
    end

    def instance_methods_candidates
      candidates_plus[:instance_methods]
    end

    def class_methods_candidates
      candidates_plus[:class_methods]
    end

    def stored?(candidate)
      cat_key = method_kind(candidate)
      store_siblings = candidates_plus[cat_key][candidate.klass_name]
      store_siblings && store_siblings.include?(candidate.method_name)
    end

    def record_outside_call(candidate)
      #TODO use a Set instead of an Array
      unless outside_called_candidates[candidate.klass_name].include?(candidate.method_name)
        outside_called_candidates[candidate.klass_name] += Array(candidate.method_name)
      end
    end

    def record_inside_call(candidate)
      #TODO use a Set instead of an Array
      unless inside_called_candidates[candidate.klass_name].include?(candidate.method_name)
        inside_called_candidates[candidate.klass_name] += Array(candidate.method_name)
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