require 'spec_helper'

describe 'at_exit() behaviour' do
  
  it 'prints the PP simpletext report to $stdout (when not in test mode)' do
    $private_please_tests_are_running = false
    allow(PrivatePlease::Reporter::SimpleText).to receive_messages(new: double(text: '<the-report-text>'))
    expect($stdout).to receive(:puts).with('<the-report-text>')
    begin
      PrivatePlease.at_exit
    ensure
      $private_please_tests_are_running = true
    end
  end

end
