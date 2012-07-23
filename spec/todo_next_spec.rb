require 'rubygems'
require 'rspec'
require 'todo_next'

todo_next(<<TEXT)
* marking 1 method
  example :
    def foo
      ..
    end
    private_please :foo

  * adds the method to $private_please_candidates

Marking 2 methods in 1 call
  example :
    ..
    private_please :foo, :bar

  * adds the 2 method to $private_please_candidates

Global usage
  example :
    ..
    private_please
      def foo .. end
      def bar .. end

  * adds the 2 method to $private_please_candidates

An outside call to a candidate marked method
  - goes through as is the method waspublic
  - $private_please_called_candidates  << the candidate
  - $private_please_INVALID_candidates << the candidate

An inside call to a candidate marked method
  - goes through
  - $private_please_called_candidates << the candidate

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
