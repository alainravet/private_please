# OPTIMISATION :
#     Calls to `$ gem ..` are slow (esp. on jruby!)
#     => we 1/ pre-perform them asynchronously (Threads) when this file is loaded,
#           2/ cache the obtained value in a variable,
#           3/ rewrite the slow method as a noop version that simply returns the cached value.

module PrivatePlease::Tracking::LoadUtils

  module GemUtils

    class << self

      # output of `gem env`
      #
      def gem_env
        GEM_ENV_PRELOADER.join.value
      end

      # the list of installed gems.
      #
      # @return ["bundle", "bundler", "rspec", ..]
      def gems_names
        GEMS_NAMES_PRELOADER.join.value
      end

    #-------------------------------------------------------------------------------------------------------------------
    private

      GEM_ENV_PRELOADER = Thread.new do
        @@_cached_gem_env = `gem env`
        def GemUtils.gem_env
          @@_cached_gem_env
        end
        @@_cached_gem_env
      end

      GEMS_NAMES_PRELOADER = Thread.new do
        @@_cached_gems_names = `gem list --no-version`
        def GemUtils.gems_names
          @@_cached_gems_names
        end
        @@_cached_gems_names
      end

    end
  end

end
