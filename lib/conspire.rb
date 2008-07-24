$LOAD_PATH << File.dirname(__FILE__)
require 'set'
require 'fileutils'

require 'rubygems'
require 'gitjour' # TODO: can we get rid of the avahi compatibility warning?

require 'conspire/gitjour_exts'
require 'conspire/conspirator'

module Conspire
  VERSION = '0.0.1'
  DEFAULTS = { :port => 7456, :name => 'conspiracy', :sync_interval => 0.5 }
  HOSTNAME = `hostname`.chomp

  @conspirators = Set.new

  module_function

  # Begin a conspiracy session
  def start(path, options)
    @options = options
    @path = path
    puts "Starting with #{@options.inspect}" if ENV['DEBUG']
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
    loop do
      Conspire.discover
      p Conspire.conspirators if ENV['DEBUG']
    end
  end

  def conspirators; @conspirators end
end
