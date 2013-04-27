require 'private_please/version'
require 'private_please/ruby_backports'
require 'private_please/candidate'
require 'private_please/configuration'
require 'private_please/storage/calls_store'
require 'private_please/storage/candidates_store'
require 'private_please/storage/methods_names'
require 'private_please/storage/methods_names_bucket'
require 'private_please/report/reporter'
require 'private_please/tracking/line_change_tracker'
require 'private_please/tracking/extension'
require 'private_please/tracking/instrumentor'
require 'private_please/tracking/all_below'

module PrivatePlease

  def self.install
    Object.send :include, PrivatePlease::Tracking::Extension
  end

#--------------
# config
#--------------

  def self.activate(flag=true)
    config.activate(flag)
  end

  def self.active?
    config.active?
  end

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

  def self.config   ; @@_config   ||= Configuration .new end

  def self.reset_before_new_test
    @@_calls_store = @@_candidates_store = nil
    @@_config  = nil
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


at_exit {
  if PrivatePlease.active?
    puts PrivatePlease.report.to_s
  end
}
