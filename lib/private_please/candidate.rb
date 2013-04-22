module PrivatePlease
  class Candidate

    attr_reader :klass,
                :klass_name,
                :method_name,
                :is_instance_method

    alias_method :instance_method?, :is_instance_method

  #-----

    def self.for_instance_method(klass, method_name)
      new(klass, method_name, true)
    end

  #-----

    def initialize(klass, method_name, is_instance_method)
      @klass, @method_name, @is_instance_method = klass, method_name, is_instance_method
      @klass_name = klass.to_s
    end

    def already_instrumented?
      PrivatePlease.storage.stored?(self)
    end
  end
end