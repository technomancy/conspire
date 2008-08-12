# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/conspire.rb'

Hoe.new('conspire', Conspire::VERSION) do |p|
  p.developer('Phil Hagelberg', 'technomancy@gmail.com')

  # TODO: tell flog about README.rdoc instead of README.txt
  p.summary = 'Conspire is a real-time collaborative editing platform using Git as a transport layer.'
  p.url = 'http://github.com/technomancy/conspire'

  # TODO: release on rubyforge once all our required dependency versions make it to rubyforge
  p.extra_deps << ['technomancy-gitjour', '6.3.0']
  p.extra_deps << 'alexvollmer-clip'
end

# vim: syntax=Ruby
