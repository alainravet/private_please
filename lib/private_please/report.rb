require 'erb'
module  PrivatePlease
  class Report

    TEMPLATE_PATH     = File.dirname(__FILE__) + '/report_templates/template.txt.erb'

    attr_reader :candidates_db, :calls_log,
                :good_candidates, :bad_candidates,
                :good_candidates_c, :bad_candidates_c,
                :never_called_candidates, :never_called_candidates_c


    def initialize(candidates_db, calls_log)
      @candidates_db = candidates_db
      @calls_log     = calls_log

      prepare_report_data
    end

    def to_s
      erb = ERB.new(File.read(TEMPLATE_PATH))
      erb.result(binding)
    end

    # @return [Hash]
    def never_called_candidates
      candidates_db.instance_methods.classes_names.each do |klass_name|
        candidates_db.instance_methods[klass_name] -= (bad_candidates[klass_name] + calls_log.internal_calls[klass_name])
      end
      candidates_db.instance_methods.reject{|_, v|v.empty?}
    end

    # @return [Hash]
    def good_candidates
      @good_candidates ||= begin
        calls_log.internal_calls.keys.each do |klass_name|
          #TODO : optimize
          calls_log.internal_calls[klass_name] -= @bad_candidates[klass_name]
        end
        calls_log.internal_calls.reject{|_, v|v.empty?}
      end.clone
    end

  private
    def prepare_report_data
      @bad_candidates   = calls_log.external_calls
      @bad_candidates_c = calls_log.class_external_calls
    end
  end
end