module PrivatePlease
  class Configuration

    attr_reader :active
    def initialize
      @active = false
    end

    def activate(flag=true)
      Object.send :include, PrivatePlease::Extension
      @active = !!flag
    end

    alias active? active
  end
end