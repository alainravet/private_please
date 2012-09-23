module PrivatePlease
  class Storage
    def self.instance
      @@__instance ||= new
    end

    def self.reset_before_new_test
      @@__instance = nil
    end

    attr_reader :candidates, :inside_called_candidates, :outside_called_candidates
    def initialize
      @candidates                = Hash.new{ [] }
      @inside_called_candidates  = Hash.new{ [] }
      @outside_called_candidates = Hash.new{ [] }
    end

    def record_candidate(self_class, name)
      candidates[self_class.to_s] += Array(name)
    end

    def record_outside_call(self_class, name)
      #TODO use a Set instead of an Array
      unless outside_called_candidates[self_class.to_s].include?(name)
        outside_called_candidates[self_class.to_s] += Array(name)
      end
    end

    def record_inside_call(self_class, name)
      #TODO use a Set instead of an Array
      unless inside_called_candidates[self_class.to_s].include?(name)
        inside_called_candidates[self_class.to_s] += Array(name)
      end
    end

  end
end