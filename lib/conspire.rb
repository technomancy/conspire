$LOAD_PATH << File.dirname(__FILE__)
require 'set'
require 'fileutils'

require 'rubygems'
require 'gitjour'

require 'conspire/gitjour_exts'
require 'conspire/conspirator'

module Conspire
  VERSION = '0.0.1'
  DEFAULT_OPTIONS = { :port => 7456, :path => Dir.pwd, :name => 'conspiracy',
    :discover_interval => 10, :sync_interval => 1 }

  @conspirators = Set.new

  module_function

  # Begin a conspiracy session
  def start(options = {})
    @options = DEFAULT_OPTIONS.merge options
    puts "Starting with #{@options.inspect}" if ENV['DEBUG']
    Gitjour::Application.start @options[:path], @options[:name], @options[:port]
  end

  # This should be called periodically
  def discover(wait = @options[:discover_interval])
    Gitjour::Application.discover(wait) do |service|
      next if service.name !~ /conspiracy/ # TODO: better way of choosing names
      next if service.port.to_i == @options[:port].to_i # TODO: and local

      # No-op if we've got it already, since @conspirators is a Set
      @conspirators << Conspirator.new(service.host, service.port, service.name)
    end
  end

  def sync_all
    @conspirators.map do |c|
      begin
        c.sync(File.dirname(@options[:path]))
      rescue => e
        puts "Dropping #{c} because #{e.message}"
        @conspirators.delete c
      end
    end
  end

  def sync_loop
    loop { sync_all and sleep @options[:sync_interval] }
  end

  def discover_loop
    loop do
      Conspire.discover
      p Conspire.conspirators if ENV['DEBUG']
    end
  end

  def conspirators; @conspirators end
end
