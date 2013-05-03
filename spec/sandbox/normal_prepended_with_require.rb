puts 'opened: ' + __FILE__

require 'private_please'
class Foo
  def self.entry_point; foo ; end 
  def self.foo; end 
end
Foo.entry_point
