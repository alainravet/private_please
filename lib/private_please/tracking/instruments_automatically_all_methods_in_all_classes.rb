
class Class

  def singleton_method_added(method_name)
    return unless $automatic_private_please_tracking
  
    return if PrivatePlease::Tracking::Utils.private_singleton_method?(self, method_name) \
           || PrivatePlease::Tracking::Utils.singleton_method_defined_by_ancestor?(self, method_name)
  
    candidate = PrivatePlease::Candidate.for_class_method(klass = self, method_name)
    PrivatePlease::Tracking::Instrumentor.add_call_tracking_code_to(candidate)
  end


  def method_added(method_name)
    return unless $automatic_private_please_tracking

    return if [:method_added].include?(method_name)
    return if PrivatePlease::Tracking::Utils.private_instance_method?(self, method_name) \
           || PrivatePlease::Tracking::Utils.instance_method_defined_by_ancestor?(self, method_name)
  
    candidate = PrivatePlease::Candidate.for_instance_method(klass = self, method_name)
    PrivatePlease::Tracking::Instrumentor.add_call_tracking_code_to(candidate)
  end

end


class Module
  
  def singleton_method_added(method_name)
    return unless $automatic_private_please_tracking

    return if [:included].include?(method_name) #&& !self.is_a?(Class)
    return if PrivatePlease::Tracking::Utils.private_singleton_method?(self, method_name)

    candidate = PrivatePlease::Candidate.for_class_method(klass = self, method_name)
    PrivatePlease::Tracking::Instrumentor.add_call_tracking_code_to(candidate)
  end


  def method_added(method_name)
    return unless $automatic_private_please_tracking

    return if [:method_added, :singleton_method_added].include?(method_name)
    return if PrivatePlease::Tracking::Utils.private_instance_method?(self, method_name)

    candidate = PrivatePlease::Candidate.for_instance_method(klass = self, method_name)
    PrivatePlease::Tracking::Instrumentor.add_call_tracking_code_to(candidate)
  end
end

