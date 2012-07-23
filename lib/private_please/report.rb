module  PrivatePlease
  class Report

    # @param [PrivatePlease::Recorder] recorder
    def self.build(storage)
      new(storage)
    end

    # @param [PrivatePlease::Recorder] recorder
    def initialize(storage)
      @storage = storage
    end

    # @return [Hash]
    def never_called_candidates
      @storage.candidates.tap do |all|
        all.keys.each do |klass|
          all[klass] = all[klass] - @storage.outside_called_candidates[klass] - @storage.inside_called_candidates[klass]
        end
      end
    end

    # @return [Hash]
    def good_candidates
      @storage.inside_called_candidates.tap do |all|
        all.keys.each do |klass|
           all[klass] = all[klass] - @storage.outside_called_candidates[klass]
        end
      end
    end

    # @return [Hash]
    def bad_candidates
      @storage.outside_called_candidates
    end
  end
end