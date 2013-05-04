require File.dirname(__FILE__) + '/data_compiler'
module  PrivatePlease ; module Reporter

  class Base

    attr_reader :data

    def initialize(candidates_store, calls_store)
      @data = DataCompiler.new(candidates_store, calls_store).compile_data
    end

  end

end end