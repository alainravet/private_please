require 'private_please/config'
require 'private_please/storage/called_methods_memory_store'
require 'private_please/tracking/debug/trace_point_data_logger'
require 'private_please/tracking/result'
require 'private_please/tracking/trace_point_details'
require 'private_please/utils/two_level_stack'

module PrivatePlease
  module Tracking
    class TracePointProcessor
      def initialize(config)
        @config                   = config

        @latest_tracepoints       = Utils::TwoLevelStack.new
        @encountered_method_calls = Storage::CalledMethodsMemoryStore.new
      end

      def process(tp)
        return if untracked_code?(tp.path)
        remember_trace_point tp
        store_method_call_details if tp.event == :call
      end

      def result
        Result.new(@encountered_method_calls)
      end

      private

      def remember_trace_point(tp)
        @latest_tracepoints.push TracePointDetails.from(tp)
        # Debug.log_to_trace_file tpd if Debug.enabled?
      end

      def untracked_code?(path)
        path.start_with?(*untracked_source_dirs)
      end

      def untracked_source_dirs
        @_untracked_source_dirs ||= begin
          Utils::RubyUtils.gems_paths +
          Array(Utils::RubyUtils.std_lib_home) +
          @config.additional_excluded_dirs
        end
      end

      def tp_curr; @latest_tracepoints.curr end
      def tp_prev; @latest_tracepoints.prev end

      def store_method_call_details
        key = tp_curr.method_full_name
        if private_call?
          @encountered_method_calls.add_private_call(key) unless already_private?
        else
          @encountered_method_calls.add_public_call(key)
        end
      end

      def private_call?
        curr_event, prev_event = tp_curr.event, tp_prev.event
        (curr_event == :call) &&
          [:line, :return, :c_return].include?(prev_event) &&
          tp_curr.same_object?(tp_prev)
      end

      def already_private?
        tp_curr._self.private_methods.include?(tp_curr.method_id)
      end
    end
  end
end
