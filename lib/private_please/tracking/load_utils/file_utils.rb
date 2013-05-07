module PrivatePlease::Tracking::LoadUtils

  module FileUtils
    class << self

      # Ex: "test/../lib/foo" -> "lib/foo"
      def simplify_path(path)
        path.gsub(/[\w]+\/\.+\//, '')
      end

    end
  end

end
