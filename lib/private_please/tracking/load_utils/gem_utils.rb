# OPTIMISATION :
#     Calls to `$ gem ..` are slow (esp. on jruby!)
#     => we 1/ pre-perform them asynchronously (Threads) when this file is loaded,
#           2/ cache the obtained value in a variable,
#           3/ rewrite the slow method as a noop version that simply returns the cached value.

module PrivatePlease::Tracking::LoadUtils

  module GemUtils

    cattr_reader_preloaded  :gems_names do
      `gem list --no-version`
    end
    cattr_reader_preloaded  :gem_env do
      `gem env`
    end

  end

end
