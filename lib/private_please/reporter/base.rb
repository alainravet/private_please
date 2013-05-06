require File.dirname(__FILE__) + '/data_compiler'
module  PrivatePlease ; module Reporter

  class Base

    def initialize(candidates_store, calls_store)
      @data = DataCompiler.new(candidates_store, calls_store).compile_data
    end

  #----------------------------------------------------------------------------
  # QUERIES:
  #----------------------------------------------------------------------------

    attr_reader :data

    def options
      PrivatePlease::Options.current
    end

  end

end end
