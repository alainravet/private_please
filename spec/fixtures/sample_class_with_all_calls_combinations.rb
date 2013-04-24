module CallsSample
                                                ###########################################
  class Simple                                  # Internal calls :                        #
                                                # -> called methods are _GOOD CANDIDATES_ #
    def make_internal_calls                     ###########################################
      instance_m_1                              #  i -> i
      self.class.class_m_1                      #  i -> C
      self.class.c_make_internal_method_calls   #  i -> C --> C
    end                                         #         +-> i

    def self.c_make_internal_method_calls       #
      class_m_1                                 #  C -> C
      new.instance_m_2                          #  C -> i
    end                                         #
  end

                                                #######################################################
  class AnotherClass                            # External calls (would fail if methods were private) #
                                                # -> called methods are _BAD CANDIDATES_              #
    def make_external_calls                     #######################################################
      Simple.new.instance_m_1                   #  i -> i
      Simple    .class_m_1                      #  i -> C
      self.class.c_make_external_calls          #  i -> C -> i
    end                                         #         -> C
    def self.c_make_external_calls              #
      Simple.new.instance_m_1                   #  C -> i
      Simple    .class_m_1                      #  C -> C
    end                                         #
    def call_the_candidate_from_inside_and_outside
      make_external_calls
      CallsSample::Simple.new.make_internal_calls
    end
  end

#-----------------------------------------------------------------------------------------------------------------------
 class Simple
    def self.not_a_candidate_c1;
      class_m_2
    end

  private_please
    def instance_m_1;   end
    def instance_m_2;   end

    def self.class_m_1;
      class_m_2
    end
    def self.class_m_2; end

    def never_called_1;             end
    def self.class_never_called_1;  end
  end
#-----------------------------------------------------------------------------------------------------------------------
end unless defined?(CallsSample::Simple)
