#---------
# Scenario
#---------
# - additional internal calls are made to bad candidates (**1 )
# - an empty   class is defined (**2 )
# - an ignored class is defined (**3 )

class SimpleCase2
  def initialize
    entry_point                     # **1
  end

  def entry_point
    baz
    self.class.c_entry_point        # **1
  end
  def baz ; end
  def never; end
  def self.c_entry_point
    c_baz
  end
  def self.c_baz ; end
  def self.c_never; end
end
SimpleCase2.new.entry_point
SimpleCase2.c_entry_point


class SimpleCase2
  class Empty                       # **2
  end
  class NotEmptyButNeverCalled      # **3
    def initialize ; neverr ; end
    def neverr ; end
  end
end

#------------------
# Expected results
#------------------

$expected_results = {
    :candidates_classes_names   => ['SimpleCase2',
                                    'SimpleCase2::NotEmptyButNeverCalled'   # will produce a (hidden) empty 3-section block
                                   ],                                       # TODO : filter it out in the DataCompiler

    :good_candidates            => {'SimpleCase2' => mnames_for([:baz])          },
    :bad_candidates             => {'SimpleCase2' => mnames_for([:entry_point])  },
    :never_called_candidates    => {'SimpleCase2'                         => mnames_for([:never]),
                                    'SimpleCase2::NotEmptyButNeverCalled' => mnames_for([:neverr])
                                   },
    :good_candidates_c          => {'SimpleCase2' => mnames_for([:c_baz])        },
    :bad_candidates_c           => {'SimpleCase2' => mnames_for([:c_entry_point])},
    :never_called_candidates_c  => {'SimpleCase2' => mnames_for([:c_never])      }
}
