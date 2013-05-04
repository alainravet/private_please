[![Build Status](https://travis-ci.org/alainravet/private_please.png?branch=master)](https://travis-ci.org/alainravet/private_please) -
[![Code Climate](https://codeclimate.com/github/alainravet/private_please.png)](https://codeclimate.com/github/alainravet/private_please)
tested with Ruby (1.8.7, 1.9.3, and 2.0.0) and JRuby(1.8 and 1.9 mode) - see [.travis.yml](.travis.yml)

## TL;DR :
Given this code
```ruby
# file : big_code
class BigCode
  def long_method # the only method that should be public
    _part_1
    _part_2
  end

  # PROBLEM : Those 2 methods were extracted and should be private
  def _part_1
    # ....
  end
  def _part_2
    # ....
  end
end
BigCode.new.long_method
```
When you run this command
```
$ pp_ruby big_code
  ^^^
```
Then the methods usage is tracked while the program runs and this findings report is output:
```
====================================================================================
=                               PrivatePlease report :                             =
====================================================================================
BigCode

    * Good candidates : can be made private :
    ------------------------------------------
      #_part_2
      #_part_1

====================================================================================
```

## Installation
```
$ gem install private_please
```

## Usage : the 2 modes (auto and manual)

You can use *private_please* (*PP*) in either **auto-mode** or in **manual mode**.  
Optionally you can customize the report contents with the env. variable ```PP_OPTIONS```.

- in **auto-mode** (the example above in TL;DR), you simply run your program with ```pp_ruby``` (instead of ```ruby```) and all your code is inspected by *PP* while it runs.
- in **manual mode** you must manually instrument (==add code to) each file you want *PP* to track and inspect.


### Auto-mode
PP will run the program and track all the classes and methods that are defined.

How to :  
- step 1 : use ```pp_ruby``` instead of ```ruby```.

Example : 
```
$ bundle exec pp_ruby -Ilib normal.rb 
              ^^^
```
A report is automatically printed when the program exits


### Manual mode
You tell PP which classes and which methods to track.

How to :  
- step 1 : Instrument your Ruby code
- step 2 : launch program as usual, with ```ruby```.


Example :
#### step 1 : Instrument your code
```ruby
# load PP
require 'private_please'                  <<<<<<<  ADD THIS (only 1x in the whole program)
PrivatePlease.pp_automatic_mode_disable   <<<<<<<     "   "   "   "   "   "   "   "   "

class BigCode

  private_please                          << ~~ JUST ADD THIS in every file you want PP to inspect
                                          <<    
                                          <<  Meaning : "track the code below"

  def long_method # the only method that should be public
    _part_1
    _part_2
  end

  def _part_1
    # ....
  end
  def _part_2
    # ....
  end
end

BigCode.new.long_method
```

####step 2 : run you code normally
```
$ ruby big_code.rb
```


## Contributing
**Please respect and reuse the current code style and formatting**

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
