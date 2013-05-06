module PrivatePlease::Tracking::LoadUtils

  module StandardLibUtils

    class << self

      def standard_lib?(requiree)
        path_base   =  "#{std_lib_home}/#{requiree}"
        if File.exists?(path_base)
          path_base
        elsif File.exists?("#{path_base}.rb")
          "#{path_base}.rb"
        end
      end

    #-------------------------------------------------------------------------------------------------------------------
    private

      # Ex:  "/Users/ara/.rbenv/versions/jruby-1.7.3/bin/jruby"
      def ruby_executable
        @@_ruby_executable ||= GemUtils.gem_env.match(/RUBY EXECUTABLE:\s*(.*)/)[1]
      end

      # Ex: "/Users/ara/.rbenv/versions/jruby-1.7.3/lib/ruby/1.9"
      def std_lib_home
        @@_std_lib_home ||= begin
          basedir      = ruby_executable.gsub(/bin\/[j]?ruby/, 'lib/ruby') # => "/Users/ara/.rbenv/versions/jruby-1.7.3/lib/ruby"
                                                  # jruby has 2+ directories of std. libs under the basedir : 1.8 and 1.9
          $:.detect {|path|                       # We choose the one that is also in the load path.
            path =~ /#{basedir}\/[12][^\/]+$/     #
          }                                       # => "/Users/ara/.rbenv/versions/jruby-1.7.3/lib/ruby/1.9"
        end                                       #                                                     ^^^ == the mode
      end

    end
  end

end
