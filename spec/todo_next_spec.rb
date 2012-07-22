require 'rubygems'
require 'rspec'
require 'todo_next'

todo_next(<<TEXT)
A Foobar
	  √ is white by default
	    ex: puts Foobar.new.colour  # => 'white'
	  * can be resized
	    example:
	      foobar.resize!(+10, -2)
	  - can be reset
	  truthiness()
	    is always true
	    is never false
	  (add more tests)
  TEXT
TEXT

# √ == passed   => same as a comment line
# * == current  => leading char - '*' - is kept
# example blocks (ex:, example:) are ignored, like comments.

#describe "<what you're testing>" do
#  specify 'this should happen' do
#    .. some code
#  end
#end
