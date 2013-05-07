$:.unshift File.expand_path(File.dirname(__FILE__) + '/../../lib')
require 'private_please'


class Good
  def initialize        ; end
  def bad_candidate_1   ; end # MUST NOT be private
end

class Fail
  def initialize
    bad_candidate_1   # this call from here triggers the incorrect report
  end
  def bad_candidate_1   ; end # MUST NOT be private
end


Fail.new.bad_candidate_1  # an external call
Good.new.bad_candidate_1  # an external call
