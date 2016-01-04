require 'private_please/tracking/trace_point_processor'

module PrivatePlease
  class MethodsCallsTracker
    def self.instance
      @instance ||= new(Config.new)
    end

    def self.reset
      @instance = nil
    end

    # -----
    attr_reader :config

    def initialize(config)
      @config                 = config
      @trace_point_processor  = Tracking::TracePointProcessor.new(config)
    end
    private_class_method :new

    def start_tracking
      tracer.enable
    end

    def stop_tracking
      tracer.disable
    end

    def result
      @trace_point_processor.result
    end

    private

    def tracer
      @_tracer ||= begin
        TracePoint.new do |tp|
          @trace_point_processor.process(tp)
        end
      end
    end
  end
end
