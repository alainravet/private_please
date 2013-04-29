require 'private_please/version'
require 'private_please/ruby_backports'
require 'private_please/candidate'
require 'private_please/storage/calls_store'
require 'private_please/storage/candidates_store'
require 'private_please/storage/methods_names'
require 'private_please/storage/methods_names_bucket'
require 'private_please/report/reporter'
require 'private_please/tracking/line_change_tracker'
require 'private_please/tracking/extension'
require 'private_please/tracking/instrumentor'
require 'private_please/tracking/instruments_all_below'
require 'private_please/tracking/automatic_mode_instrumentation'

module PrivatePlease

  def self.install
    Module.send :include, PrivatePlease::Tracking::Extension
  end

#--------------
# config
#--------------

  def self.after_method_call(candidate, outside_call)
    outside_call ?
      calls_store.store_outside_call(candidate) :
      calls_store.store_inside_call(candidate)
  end

  def self.remember_candidate(candidate)
    candidates_store.store(candidate)
  end


#--------------
# data & config containers :
#--------------

  def self.reset_before_new_test
    @@_calls_store = @@_candidates_store = nil
  end

#--------------
# report
#--------------

  def self.report
    Report::Reporter.new(candidates_store, calls_store)
  end

private

  def self.calls_store
  @@_calls_store ||= Storage::CallsStore.new
  end

  def self.candidates_store
    @@_candidates_store ||= Storage::CandidatesStore.new
  end
end


PrivatePlease.install
at_exit {
  puts PrivatePlease.report.to_s
}
