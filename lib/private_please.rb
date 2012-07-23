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

  def mark_method(method_name)
    name = method_name
    orig_method = instance_method(name)
    define_method(name) do |*args, &blk|
      set_trace_func(nil) #don't track activity while here
      self_class = self.class
      #TODO use a Set instead of an Array
      unless PrivatePlease.inside_called_candidates[self_class.to_s].include?(name)
        PrivatePlease.inside_called_candidates[self_class.to_s] += Array(name)
      end

      call_initiator = LineChangeTracker.prev_self
      is_outside_call = call_initiator.class != self_class
      if is_outside_call
        puts 'i - OUTSIDE CALL (calling this private method is normally forbidden)'
      end
      # make the call :
      orig_method.bind(self).call(*args, &blk)
      set_trace_func(LineChangeTracker::MY_TRACE_FUN)
    end
  end

  def candidates                ; Candidates.candidates                 end
  def inside_called_candidates  ; Candidates.inside_called_candidates   end

end

Module.send :include, PrivatePlease
