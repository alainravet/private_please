module PrivatePlease::Tracking

  module LoadUtils
    class << self

      def standard_lib?(requiree)
        @@_standard_lib ||= {}              # Cache results (matches and failures)
        @@_standard_lib[requiree] ||= begin # so we can quickly reject 2nd requires of gems and local libs.

          path_base   =  "#{std_lib_home}/#{requiree}"
          if File.exists?(path_base        )
            path_base
          elsif File.exists?("#{path_base}.rb")
            "#{path_base}.rb"
          end

        end
      end

    private

      def gem_env
        @@_gem_env ||= `gem env`
      end

      def ruby_executable
        @@_ruby_executable ||= gem_env.match(/RUBY EXECUTABLE:\s*(.*)/)[1]    # "/Users/ara/.rbenv/versions/1.9.3-p392/bin/ruby"
      end

      def std_lib_home
        @@_std_lib_home ||= begin
          basedir      = ruby_executable.gsub('bin/ruby', 'lib/ruby')   # "/Users/ara/.rbenv/versions/1.9.3-p392/lib/ruby"
          std_lib_home =  Dir.glob("#{basedir}/[1-3].[0-9]*").first     # "/Users/ara/.rbenv/versions/1.9.3-p392/lib/ruby/1.9.1"
        end
      end

    end
  end

end
