module PrivatePlease::Tracking

  module LoadUtils
    require File.dirname(__FILE__) + '/load_utils/file_utils'
    require File.dirname(__FILE__) + '/load_utils/gem_utils'
    require File.dirname(__FILE__) + '/load_utils/standard_lib_utils'

    class << self

      def standard_lib_or_gem?(requiree)
        (@@_standard_lib_or_gem ||= {})[requiree] ||= begin
          standard_lib?(requiree) || gem?(requiree)
        end
      end

      def standard_lib?(requiree)
        (@@_standard_lib ||= {})[requiree] ||= StandardLibUtils.standard_lib?(requiree)
      end

      def gem?(requiree)
        return false if requiree.start_with?('/')
        requiree = FileUtils.simplify_path(requiree)
        (@@_gems ||= {})[requiree] ||= begin
          base_name = requiree.include?('/') ?
              requiree.split('/').first :      #  ex:   require 'rspec/autorun'
              requiree                         #  ex:   require 'rspec'
          GemUtils.gems_names.include?(base_name)
        end

      end

    end
  end

end
