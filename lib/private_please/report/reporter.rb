require 'erb'
module  PrivatePlease ; module Report
  class Reporter

    TEMPLATE_PATH     = File.dirname(__FILE__) + '/report/templates/simple.txt.erb'

    attr_reader :candidates_store, :calls_store,
                :good_candidates, :bad_candidates,
                :good_candidates_c, :bad_candidates_c,
                :never_called_candidates, :never_called_candidates_c


    def initialize(candidates_store, calls_store)
      @candidates_store = candidates_store
      @calls_store     = calls_store

      prepare_report_data
    end

    def to_s
      erb = ERB.new(File.read(TEMPLATE_PATH))
      erb.result(binding)
    end

    # @return [Hash]
    def never_called_candidates
      candidates_store.instance_methods.classes_names.each do |klass_name|
        candidates_store.instance_methods[klass_name] -= (bad_candidates[klass_name] + calls_store.internal_calls[klass_name])
      end
      candidates_store.instance_methods.reject{|_, v|v.empty?}
    end

    # @return [Hash]
    def good_candidates
      @good_candidates ||= begin
        calls_store.internal_calls.keys.each do |klass_name|
          #TODO : optimize
          calls_store.internal_calls[klass_name] -= @bad_candidates[klass_name]
        end
        calls_store.internal_calls.reject{|_, v|v.empty?}
      end.clone
    end

  private
    def prepare_report_data
      @bad_candidates   = calls_store.external_calls
      @bad_candidates_c = calls_store.class_external_calls
    end
  end
end end