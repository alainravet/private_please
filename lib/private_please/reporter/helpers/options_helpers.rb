
DEFAULT_REPORT_OPTIONS = {
  :show_never_called_candidates_section?  => false,
  :show_bad_candidates_section?           => false,
  :show_empty_classes?                    => false
}

def options
  Object.new.tap do |o|
    def o.show_never_called_candidates_section?
      (ENV['PP_OPTIONS'] =~ /--show-never-called/) || DEFAULT_REPORT_OPTIONS[:show_never_called_candidates_section?]
    end

    def o.show_bad_candidates_section?
      (ENV['PP_OPTIONS'] =~ /--show-bad-candidates/) || DEFAULT_REPORT_OPTIONS[:show_bad_candidates_section?]
    end

    def o.show_empty_classes?
      (ENV['PP_OPTIONS'] =~ /--show-empty-classes/) || DEFAULT_REPORT_OPTIONS[:show_empty_classes?]
    end
  end
end

def options_footer_parts
  parts = []
  DEFAULT_REPORT_OPTIONS.keys.each do |key|
    display       = "--#{key}".gsub('_', '-')
    current_value = options.send(key)
    is_default    = DEFAULT_REPORT_OPTIONS[key] == current_value
    parts << [display, (is_default ? '*' : ' '), current_value]
  end
  longest_value_length = parts.map(&:first).map(&:length).max || 0
  parts.each do |p|
    p[0] = p[0].ljust(longest_value_length)
  end
  parts
end