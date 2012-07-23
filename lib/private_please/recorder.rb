module PrivatePlease
  class Recorder

    def self.instance
      @@__instance ||= new
    end

    def candidates                ; PrivatePlease.candidates              end
    def inside_called_candidates  ; Candidates.inside_called_candidates   end
    def outside_called_candidates ; Candidates.outside_called_candidates  end

    def record_candidate(self_class, name)
      #TODO move to Candidates.add_candidate + use a Set instead of an Array
      candidates[self_class.to_s] += Array(name)
    end

    def record_outside_call(self_class, name)
      #TODO move to Candidates.add_outside_call + use a Set instead of an Array
      unless outside_called_candidates[self_class.to_s].include?(name)
        outside_called_candidates[self_class.to_s] += Array(name)
      end
    end

    def record_inside_call(self_class, name)
      #TODO move to Candidates.add_inside_call + use a Set instead of an Array
      unless inside_called_candidates[self_class.to_s].include?(name)
        inside_called_candidates[self_class.to_s] += Array(name)
      end
    end

  end
end