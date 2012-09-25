require 'private_please/version'
require 'private_please/configuration'
require 'private_please/storage'
require 'private_please/report'
require 'private_please/line_change_tracker'
require 'private_please/extension'
require 'private_please/instrumentor'
require 'private_please/automatic'

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
    !!config.active
  end

  def self.record_outside_call(klass, method_name)
    storage.record_outside_call(klass, method_name)
  end

  def self.record_inside_call(klass, method_name)
    storage.record_inside_call(klass, method_name)
  end

  def self.record_candidate(klass, method_name)
    storage.record_candidate(klass, method_name)
  end

  def self.already_instrumented?(klass, method_name)
    storage.include?(klass, method_name)
  end


#--------------
# partners :
#--------------

  def self.storage  ; Storage      .instance end
  def self.config   ; Configuration.instance end

#--------------
# report
#--------------

  def self.report
    Report.build(storage)
  end

end


at_exit {
  if PrivatePlease.active?
    puts '-'*888
    puts PrivatePlease.report.to_s
  end
}
