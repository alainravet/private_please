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