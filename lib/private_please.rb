require 'private_please/version'
require 'private_please/configuration'
require 'private_please/candidates'
require 'private_please/recorder'
require 'private_please/report'
require 'private_please/line_change_tracker'

module PrivatePlease

#--------------
# config
#--------------
  def self.activate(flag)
    config.activate(flag)
  end

  def self.active?
    !!config.active
  end

#--------------
# partners :
#--------------
  def self.recorder ; Recorder     .instance end
  def self.storage  ; Candidates   .instance end
  def self.config   ; Configuration.instance end

#--------------
# report
#--------------
  def self.report
    Report.build(storage)
  end

end


require 'private_please/extension'
Module.send :include, PrivatePlease::Extension

at_exit {
  if PrivatePlease.active?
    puts '-'*888
    puts PrivatePlease.report.to_s
  end
}
