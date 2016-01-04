require 'private_please/utils/ruby_utils'

module PrivatePlease
  class Config
    attr_reader :additional_excluded_dirs

    def initialize
      @additional_excluded_dirs = ['(eval)']
    end

    def exclude_dir(val)
      additional_excluded_dirs << val
    end
  end
end
