To inspect the program 
    normal.rb 
with PrivatePlease, launch it one of these ways :

  $ ruby -rubygems   -e "require 'private_please' ; load 'normal.rb'"
or
  $ bundle exec ruby -e "require 'private_please' ; load 'normal.rb'"

You can also insert the     
   require 'private_please'
code in the program itself. (see normal_prepended_with_require.rb, line 3)


  ruby normal.rb
->
  ruby -rubygems -e "require 'private_please' ; load 'normal.rb'"
  ruby -rubygems simple_with_require.rb
  

  be ruby normal.rb
->
  be ruby -e "require 'private_please' ; load 'normal.rb'"
  be ruby simple_with_require.rb



