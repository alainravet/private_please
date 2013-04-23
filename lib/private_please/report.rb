require 'erb'
module  PrivatePlease
  class Report

    TEMPLATE_PATH     = File.dirname(__FILE__) + '/report_templates/template.txt.erb'

    attr_reader :candidates_db, :calls_log

    def initialize(candidates_db, calls_log)
      @candidates_db = candidates_db
      @calls_log     = calls_log
    end

    def to_s
      erb = ERB.new(File.read(TEMPLATE_PATH))
      erb.result(binding)
    end

    # @return [Hash]
    def never_called_candidates
      #FIXME : we *destroy* the #instance_methods_candidates, because this method is called only once, in at_exit. IMPROVE
      candidates_db.instance_methods.classes_names.each do |klass_name|
        #TODO : optimize
        candidates_db.instance_methods[klass_name] -= (calls_log.external_calls[klass_name] + calls_log.internal_calls[klass_name])
      end
      candidates_db.instance_methods
    end

    # @return [Hash]
    def good_candidates
      #FIXME : we *destroy* the #internal_calls, because this method is called only once, in at_exit. IMPROVE
      calls_log.internal_calls.keys.each do |klass_name|
        #TODO : optimize
        calls_log.internal_calls[klass_name] -= calls_log.external_calls[klass_name]
      end
      calls_log.internal_calls
    end

    # @return [Hash]
    def bad_candidates
      calls_log.external_calls
    end

  end
end