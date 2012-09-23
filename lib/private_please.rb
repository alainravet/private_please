require 'private_please/version'
require 'private_please/configuration'
require 'private_please/candidates'
require 'private_please/recorder'
require 'private_please/report'
require 'private_please/line_change_tracker'

module PrivatePlease

  def private_please(*methods_to_observe)
    klass = self
    methods_to_observe      = methods_to_observe    .collect(&:to_sym)
    class_instance_methods  = klass.instance_methods.collect(&:to_sym)

    # reject invalid methods names
    methods_to_observe.reject! do |m|
      already_defined_instance_method = class_instance_methods.include?(m)
      invalid = !already_defined_instance_method
    end

    methods_to_observe.each do |m|
      __instrument_the_observed_method(m)
    end
  end

#--------------
# config
#--------------
  def self.activate(flag)
    config.activate(flag)
  end

  def self.active?
    !!config.active
  end

#--------------
# partners :
#--------------
  def self.recorder ; Recorder     .instance end
  def self.storage  ; Candidates   .instance end
  def self.config   ; Configuration.instance end

#--------------
# report
#--------------
  def self.report
    Report.build(storage)
  end

private

  def __instrument_the_observed_method(method_name)
    klass = self
    PrivatePlease.recorder.record_candidate(klass, method_name)
    orig_method = instance_method(method_name)
    define_method(method_name) do |*args, &blk|
      set_trace_func(nil) #don't track activity while here

      if PrivatePlease.active?
        PrivatePlease.outside_call_detected?(self) ?
          PrivatePlease.recorder.record_outside_call(self.class, method_name) :
          PrivatePlease.recorder.record_inside_call( self.class, method_name)
      end

      # make the call :
      set_trace_func(LineChangeTracker::MY_TRACE_FUN)
      orig_method.bind(self).call(*args, &blk)
    end
  end

  def self.outside_call_detected?(zelf)
    call_initiator = LineChangeTracker.prev_self
    call_initiator.class != zelf.class
  end

end

Module.send :include, PrivatePlease

at_exit {
  if PrivatePlease.active?
    puts '-'*888
    puts PrivatePlease.report.to_s
  end
}
