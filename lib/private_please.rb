require 'private_please/version'
require 'private_please/candidates'
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

  def mark_method(name)
    orig_method = instance_method(name)
    define_method(name) do |*args, &blk|
      set_trace_func(nil) #don't track activity while here
      self_class = self.class

      call_initiator = LineChangeTracker.prev_self
      is_outside_call = call_initiator.class != self_class

      if is_outside_call
        #TODO use a Set instead of an Array
        unless PrivatePlease.outside_called_candidates[self_class.to_s].include?(name)
          PrivatePlease.outside_called_candidates[self_class.to_s] += Array(name)
        end
      else
        #TODO use a Set instead of an Array
        unless PrivatePlease.inside_called_candidates[self_class.to_s].include?(name)
          PrivatePlease.inside_called_candidates[self_class.to_s] += Array(name)
        end
      end
      # make the call :
      set_trace_func(LineChangeTracker::MY_TRACE_FUN)
      orig_method.bind(self).call(*args, &blk)
    end
  end

  def candidates                ; Candidates.candidates                 end
  def inside_called_candidates  ; Candidates.inside_called_candidates   end
  def outside_called_candidates ; Candidates.outside_called_candidates  end

end

Module.send :include, PrivatePlease
