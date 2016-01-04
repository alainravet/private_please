require 'yaml'

module PrivatePlease
  module Utils
    module RubyUtils
      module_function

      def gem_env
        @_gem_env ||= begin
          `gem env`
        end
      end

      # Ex: "/Users/ara/.rbenv/versions/jruby-1.7.3/lib/ruby/1.9"
      def std_lib_home
        @_std_lib_home ||= begin
          basedir = ruby_executable_path.gsub(/bin\/[j]?ruby/, 'lib/ruby')
          # => "/Users/ara/.rbenv/versions/jruby-1.7.3/lib/ruby"
          # jruby has 2+ directories of std. libs under the basedir : 1.8 and 1.9
          $LOAD_PATH.detect do |path| # We choose the one that is also in the load path.
            path =~ /#{basedir}\/[12][^\/]+$/ #
          end #                    ^^^^^^^^^^       # => "/Users/ara/.rbenv/versions/jruby-1.7.3/lib/ruby/1.9"
        end #                                                     ^^^ == the mode
      end

      # - GEM PATHS:
      #   - /Users/alain/.rvm/gems/ruby-2.3.0
      #   - /Users/alain/.rvm/gems/ruby-2.3.0@global

      def gems_paths
        @_gems_paths ||= YAML.load(gem_env)['RubyGems Environment'].detect do |hash|
          hash['GEM PATHS']
        end['GEM PATHS']
      end

      # Ex:  "/Users/ara/.rbenv/versions/jruby-1.7.3/bin/jruby"
      def ruby_executable_path
        @_ruby_executable_path ||= gem_env.match(/RUBY EXECUTABLE:\s*(.*)/)[1]
      end

      private_class_method :ruby_executable_path
    end
  end
end
