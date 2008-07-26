require 'set'
require 'fileutils'

require 'rubygems'
require 'gitjour' # TODO: can we get rid of the avahi compatibility warning?

require File.dirname(__FILE__) + '/conspire/gitjour_exts'
require File.dirname(__FILE__) + '/conspire/conspirator'

module Conspire
  VERSION = '0.1.1'
  # TODO: play with optimal intervals; perhaps auto-adjust based on latency?
  DEFAULTS = { :port => 7456, :name => 'conspiracy', :sync_interval => 0.25 }
  HOSTNAME = `hostname`.chomp # TODO: is there a better way?

  @conspirators = Set.new

  module_function

  # Begin a conspiracy session
  def start(path, options)
    @path, @options = path, options

    Gitjour::Application.init @path

    @thread = Thread.new do
      Gitjour::Application.serve(@path, @options.name, @options.port)
    end
  end

  # This should be called periodically
  def discover(wait = 5)
    Gitjour::Application.discover(wait) do |service|
      next if service.name !~ /conspiracy/ # TODO: better way of choosing names
      next if(service.port.to_i == @options.port.to_i and
              service.host.gsub(/\.local\.$/, '') == HOSTNAME)

      # No-op if we've got it already, since @conspirators is a Set
      @conspirators << Conspirator.new(service.host, service.port, service.name)
    end
  end

  # Sync with all conspirators, dropping the problematic ones
  def sync_all
    @conspirators.map do |c|
      begin
        c.sync(@path)
      rescue => e
        puts "Dropping #{c} because #{e.message}"
        @conspirators.delete c
      end
    end
  end

  def sync_loop
    loop { sync_all and sleep @options.sync_interval }
  end

  def discover_loop
    loop { discover and (p @conspirators if ENV['DEBUG']) }
  end
end
