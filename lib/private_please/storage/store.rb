require File.dirname(__FILE__) + '/calls_log'
require File.dirname(__FILE__) + '/candidates_db'
require File.dirname(__FILE__) + '/methods_names'
require File.dirname(__FILE__) + '/methods_names_bucket'

module PrivatePlease ; module Storage

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

end end