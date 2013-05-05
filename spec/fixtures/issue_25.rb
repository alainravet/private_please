require 'private_please'

require 'csv'                               ## <<==
CSV.generate("/tmp/#{Time.now}") { |_| }    ## <<==

class Foo
 def initialize; foo end
  def foo ;end
end
Foo.new

puts PrivatePlease.candidates_store.classes_names