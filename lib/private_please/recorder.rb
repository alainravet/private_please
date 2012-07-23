module PrivatePlease
  class Recorder

    def self.instance
      @@__instance ||= new(Candidates.instance)
    end

    # only used by tests  #TODO : refactor to remove .instance and .reset
    def self.reset_before_new_test
      @@__instance = nil
    end

    def initialize(storage)
      @storage = storage
    end


    def record_candidate(self_class, name)
      @storage.record_candidate(self_class, name)
      # do more. ex: logging, ..
    end

    def record_outside_call(self_class, name)
      @storage.record_outside_call(self_class, name)
      # do more. ex: logging, ..
    end

    def record_inside_call(self_class, name)
      @storage.record_inside_call(self_class, name)
      # do more. ex: logging, ..
    end

  end
end