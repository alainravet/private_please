begin
  # for  $ bundle exec ruby -r private_please doc/fixtures/empty_class.r
  PrivatePlease::Storage
rescue NameError
  # for  $ bundle exec ruby -Ilib doc/fixtures/empty_class.r
  require 'private_please'
end
PrivatePlease.pp_automatic_mode_enable
