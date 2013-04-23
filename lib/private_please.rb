require 'private_please/version'
require 'private_please/ruby_versions_compatibility'
require 'private_please/candidate'
require 'private_please/configuration'
require 'private_please/storage'
require 'private_please/report'
require 'private_please/line_change_tracker'
require 'private_please/extension'
require 'private_please/instrumentor'
require 'private_please/all_below'

module PrivatePlease

  def self.install
    Object.send :include, PrivatePlease::Extension
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

  def self.record_outside_call(candidate)
    storage.record_outside_call(candidate)
  end

  def self.record_inside_call(candidate)
    storage.record_inside_call(candidate)
  end

  def self.record_candidate(candidate)
    storage.store_candidate(candidate)
  end


#--------------
# data & config containers :
#--------------

  def self.storage  ; @@_storage  ||= Storage      .new end
  def self.config   ; @@_config   ||= Configuration.new end

  def self.reset_before_new_test
    @@_storage = nil
    @@_config  = nil
  end

#--------------
# report
#--------------

  def self.report
    Report.build(storage)
  end

end


at_exit {
  if PrivatePlease.active?
    puts PrivatePlease.report.to_s
  end
}
