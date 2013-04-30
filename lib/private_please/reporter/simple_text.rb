require File.dirname(__FILE__) + '/base'
require 'erb'
module  PrivatePlease ; module Reporter

  class SimpleText < Base

    TEMPLATE_PATH     = File.expand_path(File.dirname(__FILE__) + '/templates/simple.txt.erb')

    def text
      erb = ERB.new(File.read(TEMPLATE_PATH), 0,  "%<>")
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

      @candidates_classes_names      = (candidates_store.instance_methods.classes_names +
                                        candidates_store.class_methods   .classes_names ).uniq.sort
      @good_candidates_classes_names = (@good_candidates_c.classes_names + @good_candidates.classes_names).uniq.sort
      @bad_candidates_classes_names  = (@bad_candidates_c .classes_names + @bad_candidates .classes_names).uniq.sort
      @never_called_candidates_classes_names = (@never_called_candidates_c .classes_names + @never_called_candidates.classes_names).uniq.sort
    end
  end

end end