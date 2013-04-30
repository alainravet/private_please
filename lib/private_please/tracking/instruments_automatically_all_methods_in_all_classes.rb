
class Class
  def singleton_method_added(method_name)
    return unless $automatic_private_please_tracking
  
    is_private_class_method = singleton_class.private_method_defined?(method_name)
    return if is_private_class_method
  
    candidate = PrivatePlease::Candidate.for_class_method(klass = self, method_name)
    PrivatePlease::Tracking::Instrumentor.add_call_tracking_code_to(candidate)
  end

  def method_added(method_name)
    return unless $automatic_private_please_tracking
    return if [:method_added, :singleton_method_added].include?(method_name)
    is_private_instance_method = self.private_method_defined?(method_name)
    return if is_private_instance_method
  
    candidate = PrivatePlease::Candidate.for_instance_method(klass = self, method_name)
    PrivatePlease::Tracking::Instrumentor.add_call_tracking_code_to(candidate)
  end
end


class Module
  
  def singleton_method_added(method_name)
    return unless $automatic_private_please_tracking
    return if [:included].include?(method_name) #&& !self.is_a?(Class)
    is_private_class_method = singleton_class.private_method_defined?(method_name)
    return if is_private_class_method

    candidate = PrivatePlease::Candidate.for_class_method(klass = self, method_name)
    PrivatePlease::Tracking::Instrumentor.add_call_tracking_code_to(candidate)
  end
  #
  def method_added(method_name)
    return unless $automatic_private_please_tracking
    return if [:method_added, :singleton_method_added].include?(method_name)
    is_private_instance_method = self.private_method_defined?(method_name)
    return if is_private_instance_method

    candidate = PrivatePlease::Candidate.for_instance_method(klass = self, method_name)
    PrivatePlease::Tracking::Instrumentor.add_call_tracking_code_to(candidate)
  end
end

