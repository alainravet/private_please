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
      set_trace_func(nil)
      call_initiator = LineChangeTracker.prev_self
      if outside_call = call_initiator.class != self.class
        puts 'i - OUTSIDE CALL (calling this private method is normally forbidden)'
      else
        puts 'i - INSIDE CALL'
      end
# make the call
      orig_method.bind(self).call(*args, &blk)
      set_trace_func(LineChangeTracker::MY_TRACE_FUN)
    end
  end
  def candidates        ; Candidates.candidates         end

end

Module.send :include, PrivatePlease
