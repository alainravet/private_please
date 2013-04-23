require 'erb'
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

    TEMPLATE_PATH     = File.dirname(__FILE__) + '/report_templates/template.txt.erb'

    def to_s
      erb = ERB.new(File.read(TEMPLATE_PATH))
      erb.result(binding)
    end

    # @return [Hash]
    def never_called_candidates
      @storage.instance_methods_candidates.keys.each do |klass|
        #TODO : optimize
        @storage.instance_methods_candidates[klass] -= (@storage.external_calls[klass] + @storage.internal_calls[klass])
      end
      @storage.instance_methods_candidates
    end

    # @return [Hash]
    def good_candidates
      @storage.internal_calls.keys.each do |klass_name|
        #TODO : optimize
        @storage.internal_calls[klass_name] -= @storage.external_calls[klass_name]
      end
      @storage.internal_calls
    end

    # @return [Hash]
    def bad_candidates
      @storage.external_calls
    end
  end
end