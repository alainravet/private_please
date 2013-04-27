require 'erb'
module  PrivatePlease ; module Report
  class Reporter

    TEMPLATE_PATH     = File.dirname(__FILE__) + '/report/templates/simple.txt.erb'

    attr_reader :candidates_store, :calls_store,
                :good_candidates, :bad_candidates,
                :good_candidates_c, :bad_candidates_c,
                :never_called_candidates, :never_called_candidates_c,
                :building_time


    def initialize(candidates_store, calls_store)
      @candidates_store = candidates_store
      @calls_store      = calls_store

      prepare_report_data
    end

    def to_s
      erb = ERB.new(File.read(TEMPLATE_PATH))
      erb.result(binding)
    end

  private

    def prepare_report_data
      start_time = Time.now
      @bad_candidates   = calls_store.external_calls      .clone
      @bad_candidates_c = calls_store.class_external_calls.clone
      # TODO : optimize
      @good_candidates  = calls_store.internal_calls      .clone.remove(@bad_candidates)
      @good_candidates_c= calls_store.class_internal_calls.clone.remove(@bad_candidates_c)

      @never_called_candidates = candidates_store.instance_methods.clone.
          remove(@good_candidates).
          remove(@bad_candidates )

      @never_called_candidates_c = candidates_store.class_methods.clone.
          remove(@good_candidates_c).
          remove(@bad_candidates_c )
      @building_time = Time.now - start_time
    end
  end
end end