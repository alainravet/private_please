# Unify the Ruby APIs across versions
#

# src : https://github.com/marcandre/backports/blob/master/lib/backports/1.9.1/kernel/define_singleton_method.rb
unless Kernel.method_defined? :define_singleton_method
  module Kernel
    def define_singleton_method(*args, &block)
      class << self
        self
      end.send(:define_method, *args, &block)
    end
  end
end

# src: https://github.com/marcandre/backports/blob/master/lib/backports/1.9.2/kernel/singleton_class.rb
unless Kernel.method_defined? :singleton_class
  module Kernel
    def singleton_class
      class << self; self; end
    end
  end
end
