puts 'opened: ' + __FILE__

class Foo
  def self.entry_point; new.entry_point end 
  def entry_point; end 
end
Foo.entry_point
