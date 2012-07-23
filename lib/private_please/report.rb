module  PrivatePlease
  class Report

    # @param [PrivatePlease::Recorder] recorder
    def self.build(recorder)
      new(recorder)
    end

    # @param [PrivatePlease::Recorder] recorder
    def initialize(recorder)
      @recorder = recorder
    end

    # @return [Hash]
    def never_called_candidates
      @recorder.candidates.tap do |all|
        all.keys.each do |klass|
          all[klass] = all[klass] - @recorder.outside_called_candidates[klass] - @recorder.inside_called_candidates[klass]
        end
      end
    end

    # @return [Hash]
    def good_candidates
      @recorder.inside_called_candidates.tap do |all|
        all.keys.each do |klass|
           all[klass] = all[klass] - @recorder.outside_called_candidates[klass]
        end
      end
    end

    # @return [Hash]
    def bad_candidates
      @recorder.outside_called_candidates
    end
  end
end