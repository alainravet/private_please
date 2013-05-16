module Kernel

  # Usage :
  #   cattr_reader_preloaded :gems_names do
  #     `gem list --no-version`
  #   end
  #
  def cattr_reader_preloaded(name, &block)
    raise "initialization block is missing" unless block_given?
    cache     = "@_cached_#{name}"   .to_sym
    preloader = "@_#{name}_preloader".to_sym

    self.class.send :define_method, name, lambda {
     instance_variable_get(preloader).join.value
    }

    instance_variable_set(preloader, Thread.new do
        instance_variable_set cache, block.call
        self.class.send :define_method, name, lambda {
          instance_variable_get cache
        }
        instance_variable_get cache
    end)
  end
end
