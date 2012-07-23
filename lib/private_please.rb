require 'private_please/version'
require 'private_please/configuration'
require 'private_please/candidates'
require 'private_please/recorder'
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
# candidates
#--------------
  def candidates                ; Candidates.candidates                 end
  def inside_called_candidates  ; Candidates.inside_called_candidates   end
  def outside_called_candidates ; Candidates.outside_called_candidates  end

private

  def config
    Configuration.instance
  end

  def mark_method(name)
    orig_method = instance_method(name)
    define_method(name) do |*args, &blk|
      set_trace_func(nil) #don't track activity while here
      if PrivatePlease.active?
        self_class = self.class

        call_initiator = LineChangeTracker.prev_self
        is_outside_call = call_initiator.class != self_class
        is_outside_call ?
          PrivatePlease::Recorder.instance.record_outside_call(self_class, name) :
          PrivatePlease::Recorder.instance.record_inside_call( self_class, name)
      end

      # make the call :
      set_trace_func(LineChangeTracker::MY_TRACE_FUN)
      orig_method.bind(self).call(*args, &blk)
    end
  end


end

Module.send :include, PrivatePlease
