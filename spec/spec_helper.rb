LIB_BASEDIR = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift LIB_BASEDIR
require 'private_please'
require 'private_please/tracking/debug/trace_point_data_logger'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = [:expect, :should] }
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.before(:each) do
    PrivatePlease.reset
    PrivatePlease.exclude_dir LIB_BASEDIR
    if PrivatePlease::Debug.enabled?
      TRACES_LINES.puts
      TRACES_LINES.puts '=' * 240
      TRACES_LINES.puts self.class.description
      current_test_details = (send :eval, '@__inspect_output').delete('"').tr('(', "\n").delete(')')
      TRACES_LINES.puts current_test_details
      TRACES_LINES.puts '=' * 240
      TRACES_LINES.puts PrivatePlease::Debug::TracePointDataLogger.header
      TRACES_LINES.puts '=' * 240
      TRACES_LINES.flush
    end
  end
end

def assert_result_equal(expected)
  PrivatePlease.stop_tracking
  # test result
  PrivatePlease.privatazable_methods.should == expected
end

def assert_result_is_empty
  assert_result_equal({})
end
