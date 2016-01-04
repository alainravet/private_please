require 'private_please/utils/ruby_utils'
require 'private_please/utils/source_file_utils'

module PrivatePlease
  module Tracking
    class MethodDetails < Struct.new(:klass, :separator, :method, :source_path, :lineno)
      METHOD_AS_KEY_PATTERN = /(?<klass>.*)
                               (?<separator>[#.])
                               (?<method>.*)
                              /x

      def self.from_class_plus_method(class_plus_method)
        md = class_plus_method.match(METHOD_AS_KEY_PATTERN)
        klass     = Object.const_get(md[:klass])
        separator = md[:separator]
        method    = md[:method].to_sym
        source_path, lineno = Utils::SourceFileUtils.source_path_and_lineno(klass, separator, method)

        new(klass, separator, method, source_path, lineno)
      end

      def separator_plus_method
        "#{separator}#{method}"
      end
    end
  end
end
