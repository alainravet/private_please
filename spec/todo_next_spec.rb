require 'rubygems'
require 'rspec'
require 'todo_next'

todo_next(<<TEXT)
Single-method usage
  example :
    def foo
      ..
    end
    private_please :foo

  * $private_please_candidates == [:foo]

Multi-method usage
  example :
    ..
    private_please :foo, :bar

  - $private_please_candidates == [:foo, :bar]

Global usage
  example :
    ..
    private_please
      def foo .. end
      def bar .. end

  - $private_please_candidates == [:foo, :bar]

An outside call to a candidate marked method
  - goes through as is the method waspublic
  - $private_please_called_candidates  << the candidate
  - $private_please_INVALID_candidates << the candidate

An inside call to a candidate marked method
  - goes through
  - $private_please_called_candidates << the candidate

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

Configuration
  - 'private_please' is inactive by default
  'private_please' can be activate
    - via ENV['private_please']=true
    - PrivatePlease.activate(true)

at_exit
  - prints a report about the candidates in STDOUT

TEXT

# √ == passed   => same as a comment line
# * == current  => leading char - '*' - is kept
