module PrivatePlease

  class Options

    DEFAULTS = {
      :show_never_called_candidates_section?  => false,
      :show_bad_candidates_section?           => false,
      :show_empty_classes?                    => false
    }

    def self.current
      @@_current ||= new
    end

  #----------------------------------------------------------------------------
  # QUERIES:
  #----------------------------------------------------------------------------

    def default?(key, value)
      DEFAULTS[key] == value
    end

    def only_show_good_candidates?
      [show_never_called_candidates_section? ,
       show_bad_candidates_section?
      ].none?
    end

    def show_never_called_candidates_section?
      (ENV['PP_OPTIONS'] =~ /--show-never-called/)   || DEFAULTS[:show_never_called_candidates_section?]
    end

    def show_bad_candidates_section?
      (ENV['PP_OPTIONS'] =~ /--show-bad-candidates/) || DEFAULTS[:show_bad_candidates_section?]
    end

    def show_empty_classes?
      (ENV['PP_OPTIONS'] =~ /--show-empty-classes/)  || DEFAULTS[:show_empty_classes?]
    end

  end

end
