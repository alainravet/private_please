require 'private_please/version'
require 'private_please/ruby_versions_compatibility'
require 'private_please/candidate'
require 'private_please/configuration'
require 'private_please/storage/store'
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

  def self.log_method_call(candidate, outside_call)
    outside_call ?
      calls_log.record_outside_call(candidate) :
      calls_log.record_inside_call(candidate)
  end

  def self.record_candidate(candidate)
    candidates_db.store_candidate(candidate)
  end


#--------------
# data & config containers :
#--------------

  def self.storage  ; @@_storage  ||= Storage::Store.new end
  def self.config   ; @@_config   ||= Configuration .new end

  def self.reset_before_new_test
    @@_storage = nil
    @@_config  = nil
  end

#--------------
# report
#--------------

  def self.report
    Report::Reporter.new(candidates_db, calls_log)
  end

private

  def self.calls_log ;     storage.calls_log     end
  def self.candidates_db ; storage.candidates_db end
end


at_exit {
  if PrivatePlease.active?
    puts PrivatePlease.report.to_s
  end
}
