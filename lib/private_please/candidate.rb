# Holds the details of 1 method that was marked via `private_please`.

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

    def self.for_class_method(klass, method_name)
      new(klass, method_name, false)
    end

  #-----

    def initialize(klass, method_name, is_instance_method)
      @klass, @method_name, @is_instance_method = klass, method_name, is_instance_method
      @klass_name = klass.to_s
    end

    def already_instrumented?
      candidates_db.stored_candidate?(self)
    end

  private

    def candidates_db
      PrivatePlease.storage.candidates_db
    end
  end
end