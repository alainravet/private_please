require File.dirname(__FILE__) + '/store/candidates_db'
require File.dirname(__FILE__) + '/store/calls_log'

module PrivatePlease
  class Store

    def initialize
      @candidates_db   = CandidatesDB.new
      @calls_log       = CallsLog.new
    end

  #--------
  # QUERIES:
  #--------

    attr_reader :candidates_db, :calls_log

  end
end