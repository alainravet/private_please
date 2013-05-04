#---------
# Setup
#---------

class SimpleCase1
  def entry_point; baz ; end
  def baz ; end
  def never; end
  def self.c_entry_point; c_baz ; end
  def self.c_baz ; end
  def self.c_never; end
end
SimpleCase1.new.entry_point
SimpleCase1.c_entry_point

#------------------
# Expected results
#------------------

$expected_results = {
    :candidates_classes_names   => ['SimpleCase1'],

    :good_candidates            => {'SimpleCase1' => mnames_for([:baz])          },
    :bad_candidates             => {'SimpleCase1' => mnames_for([:entry_point])  },
    :never_called_candidates    => {'SimpleCase1' => mnames_for([:never])        },

    :good_candidates_c          => {'SimpleCase1' => mnames_for([:c_baz])        },
    :bad_candidates_c           => {'SimpleCase1' => mnames_for([:c_entry_point])},
    :never_called_candidates_c  => {'SimpleCase1' => mnames_for([:c_never])      }
}
