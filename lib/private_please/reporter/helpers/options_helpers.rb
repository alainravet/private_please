
def options
  PrivatePlease::Options.current
end

class OptionLine < Struct.new(:label, :value, :is_default)
end

def options_footer_parts
  [].tap do |parts|
    PrivatePlease::Options::DEFAULTS.keys.each do |key|
      parts << OptionLine.new(
          display       = "--#{key}".gsub('_', '-').gsub('?', ''),
          current_value = options.send(key),
          is_default    = options.default?(key, current_value)
      )
    end
    longest_label_len = parts.map(&:label).map(&:length).max
    parts.each do |p|
      p.label = p.label.ljust(longest_label_len)
    end if longest_label_len
  end
end
