module PrivatePlease
  class Configuration
    def self.instance
      @@__instance ||= new
    end

    def self.reset
      @@__instance = nil
    end

    attr_reader :active
    def initialize
      @active
    end

    def activate(flag)
      @active = flag
    end
  end
end