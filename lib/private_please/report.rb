module  PrivatePlease
  class Report

    # @param [PrivatePlease::Storage] storage
    def self.build(storage)
      Report.new(storage)
    end

    # @param [PrivatePlease::Storage] storage
    def initialize(storage)
      @storage = storage
    end

    TEMPLATE_PATH     = File.dirname(__FILE__) + '/report/template.txt.erb'

    def to_s
      erb = ERB.new(File.read(TEMPLATE_PATH))

      good_candidates = good_candidates() # for ERB/binding
      bad_candidates  = bad_candidates()  # for ERB/binding
      erb.result(binding)
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