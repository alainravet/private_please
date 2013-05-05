# Fails with 1.8.7, works with 1.9.3, 2.0.0
require 'private_please'
require 'rubygems'
require 'coderay'
print CodeRay.scan('puts "Hello, world!"', :ruby).inspect # OK
print CodeRay.scan('puts "Hello, world!"', :ruby).html    # FAIL
