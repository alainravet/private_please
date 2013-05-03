
def show_never_called_candidates_section?
  ENV['PP_OPTIONS'] =~ /--show-never-called/
end

def show_bad_candidates_section?
  ENV['PP_OPTIONS'] =~ /--show-bad-candidates/
end

def show_empty_classes?
  ENV['PP_OPTIONS'] =~ /--show-empty-classes/
end
