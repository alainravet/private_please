# Unify the Ruby APIs across versions
#
class Object

  def self.class_method(name)
    (class << self; self; end).send :instance_method, name
  end  unless Object.respond_to? :class_method

  def define_singleton_method(name, &block)
      (class<<self;self;end).send(:define_method, name, &block)
  end unless Object.respond_to? :define_singleton_method

end
