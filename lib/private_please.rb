require 'private_please/version'
require 'private_please/configuration'
require 'private_please/candidates'
require 'private_please/recorder'
require 'private_please/report'
require 'private_please/line_change_tracker'

module PrivatePlease

  def private_please(*args)
    klass = self
    args.reject!{|m| !klass.instance_methods.include?(m.to_s)}
    candidates[klass.to_s] += args
    args.each do |m|
      mark_method(m)
    end
  end

#--------------
# config
#--------------
  def activate(flag)
    config.activate(flag)
  end

  def active?
    !!config.active
  end

#--------------
# partners :
#--------------
  def recorder ; Recorder     .instance end
  def storage  ; Candidates   .instance end
  def config   ; Configuration.instance end

  def self.reset_before_new_test
    Recorder      .reset_before_new_test
    Candidates    .reset_before_new_test
    Configuration .reset_before_new_test
  end


#--------------
# candidates
#--------------


  def candidates                ; storage.candidates                 end
  def inside_called_candidates  ; storage.inside_called_candidates   end
  def outside_called_candidates ; storage.outside_called_candidates  end

#--------------
# report
#--------------
  def report
    Report.build(storage)
  end

private

  def mark_method(name)
    self_class = self.class
    PrivatePlease.recorder.record_candidate(self_class, name)
    orig_method = instance_method(name)
    define_method(name) do |*args, &blk|
      set_trace_func(nil) #don't track activity while here

      self_class = self.class
      if PrivatePlease.active?
        call_initiator = LineChangeTracker.prev_self
        is_outside_call = call_initiator.class != self_class
        is_outside_call ?
          PrivatePlease.recorder.record_outside_call(self_class, name) :
          PrivatePlease.recorder.record_inside_call( self_class, name)
      end

      # make the call :
      set_trace_func(LineChangeTracker::MY_TRACE_FUN)
      orig_method.bind(self).call(*args, &blk)
    end
  end


end

Module.send :include, PrivatePlease
