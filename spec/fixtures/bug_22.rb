load File.expand_path File.dirname(__FILE__) + '/../../doc/fixtures/fixture_helper.rb'

module Extra
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def a_class_method_via_module_Extra ; end
  end
end


class Simple
  include Extra
end
Simple.a_class_method_via_module_Extra

