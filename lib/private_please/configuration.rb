module PrivatePlease
  class Configuration
    def self.instance
      @@__instance ||= new
    end

    # only used by tests  #TODO : refactor to remove .instance and .reset
    def self.reset_before_new_test
      @@__instance = nil
    end

    attr_reader :active
    def initialize
      @active
    end

    def activate(flag=true)
      Object.send :include, PrivatePlease::Extension
      @active = flag
    end
  end
end