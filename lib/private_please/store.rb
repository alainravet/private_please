require File.dirname(__FILE__) + '/store/candidates_db'
require File.dirname(__FILE__) + '/store/calls_log'

module PrivatePlease
  class Store
    attr_reader :candidates_db, :calls_log

    def initialize
      @candidates_db   = CandidatesDB.new
      @calls_log       = CallsLog.new
    end

  end
end