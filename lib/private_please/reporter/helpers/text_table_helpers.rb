
def table_for(col_1, col_2)
  PrivatePlease::Report::Table.new(col_1, col_2)
end

def names_from(class_name, candidates, prefix)
  candidates.get_methods_names(class_name).collect{|n|"#{prefix}#{n}"}
end

