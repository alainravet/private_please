require 'private_please/version'

require 'cattr_reader_preloaded'

require 'private_please/ruby_backports'
require 'private_please/candidate'
require 'private_please/storage'
require 'private_please/report'
require 'private_please/reporter'
require 'private_please/options'

at_exit do
  error_detected = $!
  PrivatePlease.at_exit unless error_detected
end

module PrivatePlease

  def self.install
    Module.send :include, PrivatePlease::Tracking::Extension
    PrivatePlease.pp_automatic_mode_enable
    set_trace_func PrivatePlease::Tracking::LineChangeTracker::MY_TRACE_FUN
  end

  def self.pp_automatic_mode_enabled? ; !!$pp_automatic_mode_enabled          end
  def self.pp_automatic_mode_enable(value=true)
    $pp_automatic_mode_enabled =  value
  end
  def self.pp_automatic_mode_disable  ;   $pp_automatic_mode_enabled = false  end

  # TODO : replace class methods by PP instance + instance methods
  def self.calls_store
    @@_calls_store ||= Storage::CallsStore.new
  end

  def self.candidates_store
    @@_candidates_store ||= Storage::CandidatesStore.new
  end

  def self.reset
    @@_candidates_store = @@_calls_store = nil
    Tracking::LineChangeTracker.reset
    set_trace_func nil
  end

  def self.at_exit
    report = PrivatePlease::Reporter::SimpleText.new(PrivatePlease.candidates_store, PrivatePlease.calls_store)
    unless $private_please_tests_are_running
      $stdout.puts report.text
    end
  end
end

require 'private_please/tracking'

PrivatePlease.install
