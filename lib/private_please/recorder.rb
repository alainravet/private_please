module PrivatePlease
  class Recorder

    def self.instance
      @@__instance ||= new
    end

    def record_outside_call(self_class, name)
      #TODO use a Set instead of an Array
      unless PrivatePlease.outside_called_candidates[self_class.to_s].include?(name)
        PrivatePlease.outside_called_candidates[self_class.to_s] += Array(name)
      end
    end

    def record_inside_call(self_class, name)
      #TODO use a Set instead of an Array
      unless PrivatePlease.inside_called_candidates[self_class.to_s].include?(name)
        PrivatePlease.inside_called_candidates[self_class.to_s] += Array(name)
      end
    end

  end
end