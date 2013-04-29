# PrivatePlease

[![Build Status](https://travis-ci.org/alainravet/private_please.png?branch=master)](https://travis-ci.org/alainravet/private_please)
(master)
[![Build Status](https://travis-ci.org/alainravet/private_please.png?branch=nextversion)](https://travis-ci.org/alainravet/private_please)
(nextversion)

tested with Ruby (1.8.7, 1.9.3, and 2.0.0) and JRuby(1.8 and 1.9 mode) - see .travis.yml

## Installation

Add this line to your application's Gemfile:

    gem 'private_please'

## Usage

```ruby

require 'private_please'        # step 1

class CouldBeMorePrivate
  def to_s                      # not observed -> won't appear in the report.
    # ...
  end

  private_please # << ~~~~~~~~~~~~~~ # step 2 : start observing ~~~~~~~~~~~~~~~~~~*

  def do_the_thing                  # is called by class' users => must stay public (case #1)
    part_1
    part_2
  end
  def part_1 ; end                  # only called by #do_the_thing => should be private (case #2)
  def part_2 ; end                  # only called by #do_the_thing => should be private (case #2)

  def part_3 ; end                  # is never used -> will be detected. (case #3)
end

c = CouldBeMorePrivate.new  
c.do_the_thing				    # step 3 : execute the code, so PP can observe and deduce.
```
A report is automatically printed in the console when the program exits.
For the code above, the report would be :

    ====================================================================================
    =                               PrivatePlease report :                             =
    ====================================================================================

    **********************************************************
    CouldBeMorePrivate
    **********************************************************

        * Good candidates : can be made private :
        ------------------------------------------

            #part_1
            #part_2

        * Bad candidates : must stay public/protected
        ------------------------------------------

            #do_the_thing

        * Methods that were never called
        ------------------------------------------

            #part_3

    ====================================================================================


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
