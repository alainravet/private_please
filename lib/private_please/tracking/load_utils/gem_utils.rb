module PrivatePlease::Tracking::LoadUtils

  module GemUtils

     cattr_reader_preloaded(:gem_env   ) { `gem env`                }
     cattr_reader_preloaded(:gems_names) { `gem list --no-version`  }

  end

end
