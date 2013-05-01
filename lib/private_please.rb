require 'private_please/version'
require 'private_please/ruby_backports'
require 'private_please/candidate'
require 'private_please/storage'
require 'private_please/reporter'
require 'private_please/tracking'

module PrivatePlease

  def self.install
    Module.send :include, PrivatePlease::Tracking::Extension
  end

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
end


at_exit {
  report = PrivatePlease::Reporter::SimpleText.new(PrivatePlease.candidates_store, PrivatePlease.calls_store)
  $stdout.puts report.text
}

PrivatePlease.install
if $automatic_private_please_tracking
  set_trace_func PrivatePlease::Tracking::LineChangeTracker::MY_TRACE_FUN
end