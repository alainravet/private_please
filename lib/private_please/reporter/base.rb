module  PrivatePlease ; module Reporter

  class Base

    attr_reader :candidates_store, :calls_store,
                :good_candidates, :bad_candidates,
                :good_candidates_c, :bad_candidates_c,
                :never_called_candidates, :never_called_candidates_c,
                :building_time


    def initialize(candidates_store, calls_store)
      @candidates_store = candidates_store
      @calls_store      = calls_store

      start_time = Time.now
      prepare_report_data
      @building_time = Time.now - start_time
    end

  private

    def prepare_report_data
      raise "prepare_report_data() ot implemented in the child class"
    end
  end

end end