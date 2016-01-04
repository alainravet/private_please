require 'private_please/version'
require 'private_please/methods_calls_tracker'
require 'private_please/reporting/simple_text'

module PrivatePlease
  def self.instance
    MethodsCallsTracker.instance
  end

  def self.reset
    MethodsCallsTracker.reset
  end

  def self.report
    Reporting::SimpleText.new(instance.result).text
  end

  def self.config
    instance.config
  end

  def self.track(reset: true, &block)
    reset if reset
    start_tracking
    block.call
    stop_tracking
  end

  def self.start_tracking
    instance.start_tracking
  end

  def self.stop_tracking
    instance.stop_tracking
  end

  def self.exclude_dir(val)
    config.exclude_dir val
  end

  def self.privatazable_methods
    instance.result.to_two_level_hash
  end
end
