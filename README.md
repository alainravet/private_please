-[![Build Status](https://travis-ci.org/alainravet/private_please.png?branch=master)](https://travis-ci.org/alainravet/private_please) -
-[![Code Climate](https://codeclimate.com/github/alainravet/private_please.png)](https://codeclimate.com/github/alainravet/private_please)
-[![Coverage Status](https://coveralls.io/repos/alainravet/private_please/badge.png)](https://coveralls.io/r/alainravet/private_please)
tested with Ruby 2.0.0..2.3.0 - see [.travis.yml](.travis.yml)
# PrivatePlease

This tool locates public or protected methods that can be made private.
After you have instrumented the tests suite (see below), it watches the code as the tests are executed and identifies non-private methods that are only called privately.
As the technique used is tracing, the execution is slowed down substantially (ex: 300%)

[![asciicast](https://asciinema.org/a/4sqa7u4defes3akyst27pq066.png)](https://asciinema.org/a/4sqa7u4defes3akyst27pq066)

## Usage

Add this to the top of `spec_helper.rb`:

```ruby
require 'private_please'
PrivatePlease.start_tracking
at_exit { puts PrivatePlease.report }
...

```

Optionally, you can `exclude_dir` the tests code, local gems, or any source dir that could touched when running the tests.
```ruby
SPECS_DIR  = File.dirname(__FILE__)
require 'private_please'
PrivatePlease.exclude_dir SPECS_DIR                  # don't analyze the tests
PrivatePlease.exclude_dir '/dev/my_local_gem'        # specified via path: in Gemfile
PrivatePlease.exclude_dir '/Applications/RubyMine.app/Contents/rb/testing'
PrivatePlease.start_tracking
at_exit { puts PrivatePlease.report.gsub(Rails.root.to_s, '') }
...

```

### Example of result :

```
265 examples, 0 failures, 2 pending

====================================================================================
=                               Privatazable methods :                             =
====================================================================================
/app/controllers/application_controller.rb
    21  ApplicationController::MissingAvatars#must_remind_user_to_setup_avatar?
    75  ApplicationController#allow?
/app/controllers/home_controller.rb
    15  HomeController#redirect_to_default_page_for_signed_in_users
/app/controllers/mentor_profiles_controller.rb
     4  MentorProfilesController#after_create_success

```
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'private_please'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install private_please

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alainravet/private_please.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

