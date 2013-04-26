require File.dirname(__FILE__) + '/calls_store'
require File.dirname(__FILE__) + '/candidates_store'
require File.dirname(__FILE__) + '/methods_names'
require File.dirname(__FILE__) + '/methods_names_bucket'

module PrivatePlease ; module Storage

  class Store

    def initialize
      @candidates_store   = CandidatesStore.new
      @calls_store       = CallsStore.new
    end

  #--------
  # QUERIES:
  #--------

    attr_reader :candidates_store, :calls_store

  end

end end