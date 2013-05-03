require 'spec_helper'

describe 'at_exit() behaviour' do
  
  it 'prints the PP simpletext report to $stdout (when not in test mode)' do
    $private_please_tests_are_running = false
    PrivatePlease::Reporter::SimpleText.stub(:new => stub(:text => '<the-report-text>'))
    $stdout.
        should_receive(:puts).
        with('<the-report-text>')
    begin
      PrivatePlease.at_exit
    ensure
      $private_please_tests_are_running = true
    end
  end

end