#----------

def mnames_for(args)
  PrivatePlease::Storage::MethodsNames.new(Array(args))
end

#----------

class Hash
  def to_methods_names_bucket
    PrivatePlease::Storage::MethodsNamesBucket.new.tap do |bucket|
      each_pair do |class_name, method_names_as_a|
        method_names_as_a.each do |method_name|
          bucket.add_method_name(class_name, method_name)
        end
      end
    end
  end
end

def assert_instance_methods_candidates(raw_expected)
  expected = raw_expected.to_methods_names_bucket if raw_expected.is_a?(Hash)
  PrivatePlease.candidates_store.instance_methods.should == expected
end

def assert_class_methods_candidates(raw_expected)
  expected = raw_expected.to_methods_names_bucket if raw_expected.is_a?(Hash)
  PrivatePlease.candidates_store.class_methods.should == expected
end
alias :assert_singleton_methods_candidates :assert_class_methods_candidates

#----------

def assert_calls_detected(expected)
  calls_db = PrivatePlease.calls_store
  { :inside    => calls_db.internal_calls,
    :inside_c  => calls_db.class_internal_calls,
    :outside   => calls_db.external_calls,
    :outside_c => calls_db.class_external_calls
  }.should == expected
end

NO_CALLS_OBSERVED = {}

def assert_no_calls_detected
  assert_calls_detected :inside   => NO_CALLS_OBSERVED, :outside   => NO_CALLS_OBSERVED,
                        :inside_c => NO_CALLS_OBSERVED, :outside_c => NO_CALLS_OBSERVED
end

#----------
# Reporter::DataCompiler :
#----------

def run_and_inspect(fixture_file, __file__)
  PrivatePlease.pp_automatic_mode_enable
  load File.expand_path(File.dirname(__file__) + "/fixtures/#{fixture_file}")
  c = PrivatePlease::Reporter::DataCompiler.new(PrivatePlease.candidates_store, PrivatePlease.calls_store)
  data = c.compile_data
end

def assert_report_data_matches(data, expected_results = $expected_results)
  ['candidates_classes_names',  data.candidates_classes_names ].should == ['candidates_classes_names',  expected_results[:candidates_classes_names ]]
  ['good_candidates',           data.good_candidates          ].should == ['good_candidates',           expected_results[:good_candidates          ]]
  ['bad_candidates',            data.bad_candidates           ].should == ['bad_candidates',            expected_results[:bad_candidates           ]]
  ['never_called_candidates',   data.never_called_candidates  ].should == ['never_called_candidates',   expected_results[:never_called_candidates  ]]
  ['good_candidates_c',         data.good_candidates_c        ].should == ['good_candidates_c',         expected_results[:good_candidates_c        ]]
  ['bad_candidates_c',          data.bad_candidates_c         ].should == ['bad_candidates_c',          expected_results[:bad_candidates_c         ]]
  ['never_called_candidates_c', data.never_called_candidates_c].should == ['never_called_candidates_c', expected_results[:never_called_candidates_c]]
end

#----------