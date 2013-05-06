# OPTIMISATION :
#     Calls to `$ gem ..` are slow (esp. on jruby!)
#     => we 1/ pre-perform them asynchronously (Threads) when this file is loaded,
#           2/ cache the obtained value in a variable,
#           3/ rewrite the slow method as a noop version that simply returns the cached value.

module PrivatePlease::Tracking::LoadUtils

  module GemUtils

    class << self

      # performs `$ gem env`
      #
      def gem_env
        GEM_ENV_PRELOADER.join
        gem_env     # call the fast/just rewritten version
      end

      # performs `$ gem list` + extracts the names
      #
      def gems_names
        GEMS_NAMES_PRELOADER.join
        gems_names
      end

    #-------------------------------------------------------------------------------------------------------------------
    private

      GEM_ENV_PRELOADER = Thread.new do
        @@_cached_gem_env = `gem env`
        def GemUtils.gem_env
          @@_cached_gem_env
        end
      end

      GEMS_NAMES_PRELOADER = Thread.new do
        @@_cached_gems_names = `gem list`.  # very slow on jruby
            split("\n").
            map { |l| l.match(/(\S+)\s+.*/)[1]}                # ["bundle", "bundler", "rspec", ..]
        def GemUtils.gems_names
          @@_cached_gems_names
        end
      end

    end
  end

end
