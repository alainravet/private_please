module  PrivatePlease ; module Reporter

  class Data < Struct.new(
                :candidates_classes_names,
                :good_candidates,   :bad_candidates,   :never_called_candidates,
                :good_candidates_c, :bad_candidates_c, :never_called_candidates_c,
                :building_time
              )
  end

  class DataCompiler

    def initialize(candidates_store, calls_store)
      @candidates_store = candidates_store
      @calls_store      = calls_store
    end

    # TODO : optimize (with Hamster?)
    def compile_data
      start_time = Time.now

      bad_candidates,
      bad_candidates_c          = read_bad_candidates
      candidates_classes_names  = read_candidates_classes_names

      good_candidates,
      good_candidates_c         = compute_good_candidates(bad_candidates, bad_candidates_c)

      never_called_candidates,
      never_called_candidates_c = compute_never_called_candidates(good_candidates,   bad_candidates,
                                                                  good_candidates_c, bad_candidates_c)

      remove_candidates_with_no_methods!(bad_candidates,   good_candidates,   never_called_candidates,
                                         bad_candidates_c, good_candidates_c, never_called_candidates_c)
      building_time = Time.now - start_time

      Data.new(
            candidates_classes_names,
            good_candidates,   bad_candidates,   never_called_candidates,
            good_candidates_c, bad_candidates_c, never_called_candidates_c,
            building_time
      )
    end

  private

    def read_candidates_classes_names
      @candidates_store.classes_names.sort
    end

    def read_bad_candidates
      [ bad_candidates    = @calls_store.external_calls,
        bad_candidates_c  = @calls_store.class_external_calls
      ]
    end

    def compute_good_candidates(bad_candidates, bad_candidates_c)
      [ good_candidates   = @calls_store.internal_calls      .clone.remove(bad_candidates),
        good_candidates_c = @calls_store.class_internal_calls.clone.remove(bad_candidates_c)
      ]
    end

    def compute_never_called_candidates(good_candidates, bad_candidates, good_candidates_c, bad_candidates_c)
      never_called_candidates = @candidates_store.instance_methods.clone.
          remove(good_candidates).
          remove(bad_candidates)

      never_called_candidates_c = @candidates_store.class_methods.clone.
          remove(good_candidates_c).
          remove(bad_candidates_c)
      [never_called_candidates, never_called_candidates_c]
    end

    def remove_candidates_with_no_methods!(bad_candidates, good_candidates, never_called_candidates, bad_candidates_c, good_candidates_c, never_called_candidates_c)
      [
          bad_candidates, bad_candidates_c, good_candidates, good_candidates_c, never_called_candidates, never_called_candidates_c
      ].each { |arr| arr.reject! { |k, v| v.empty? } }
    end

  end

end end