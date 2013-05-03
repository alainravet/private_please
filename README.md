```
Helps you locate the public/protected methods that could be made private.
```
tested with Ruby (1.8.7, 1.9.3, and 2.0.0) and JRuby(1.8 and 1.9 mode) - see [.travis.yml](.travis.yml)

[![Build Status](https://travis-ci.org/alainravet/private_please.png?branch=master)](https://travis-ci.org/alainravet/private_please) -
[![Code Climate](https://codeclimate.com/github/alainravet/private_please.png)](https://codeclimate.com/github/alainravet/private_please)

## The problem

Too often people refactor (with *Extract Method* )
```ruby
class BigCode
  def long_method
    ..
  end
end
```
into
```ruby
class BigCode
  def long_method
    part_1
    part_2
  end
  def part_1
    ..
  end
  def part_2
    ..
  end
end
```

instead of
```ruby
class BigCode
  def long_method
    part_1
    part_2
  end
private  <<<<< <<<<< <<<<< <<<<<
  def part_1
    ..
  end
  def part_2
    ..
  end
end
```
Where there was 1 public method, there are now 3.  
The API of the class has broadened for no valid reason.  
This gem helps you identify those methods that should have been made private in the first place.


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

                                # step 2 : tell PP where to start observing :
  private_please # << ~~ JUST ADD THIS ~~~~ ~~~~ ~~~~ ~~~~

  def do_the_thing                  # is called by the class' users => must stay public (case #1)
    part_1
    part_2
  end
  def part_1 ; end                  # only called by #do_the_thing  => could be private  (case #2)
  def part_2 ; end                  #   ..    ..    ..    ..    ..    ..    ..    ..    ..    ..

  def part_3 ; end                  # is never used                 => could be removed  (case #3)
end

c = CouldBeMorePrivate.new
c.do_the_thing  			    # step 3 : execute the code, so PP can observe and deduce.
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
