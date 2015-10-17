# This file was (originally) generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

module PrivatePlease
  def self.reset_before_new_test
    PrivatePlease .reset_before_new_test
  end
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = [:expect, :should] }
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:each) do
    PrivatePlease.reset
    PrivatePlease.pp_automatic_mode_disable
  end
end

require '_helpers/assert_helpers'

#--------------------------------------------------------

require File.dirname(__FILE__) + '/../lib/private_please'
PrivatePlease.pp_automatic_mode_disable

$private_please_tests_are_running = true

require 'coveralls'
Coveralls.wear!
