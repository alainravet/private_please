module PrivatePlease
  class Storage

    attr_reader :candidates, :inside_called_candidates, :outside_called_candidates
    def initialize
      @candidates                = Hash.new{ [] }
      @inside_called_candidates  = Hash.new{ [] }
      @outside_called_candidates = Hash.new{ [] }
    end

    def store(candidate)
      candidates[candidate.klass_name] += Array(candidate.method_name)
    end

    def stored?(candidate)
      (candidates[candidate.klass_name] || []).include?(candidate.method_name)
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

  end
end