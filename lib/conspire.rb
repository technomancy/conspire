$LOAD_PATH << File.dirname(__FILE__)
require 'set'
require 'fileutils'

require 'rubygems'
require 'gitjour'
require 'mojombo-grit'

require 'conspire/gitjour_exts'
require 'conspire/conspirator'

module Conspire
  VERSION = '0.0.1'
  DEFAULT_OPTIONS = { :port => 7456, :path => Dir.pwd }
  SERVICE_NAME = 'conspire'
  DISCOVER_TIME = 2

  @conspirators = Set.new

  module_function

  # Begin a conspiracy session
  def start(options = {})
    @options = DEFAULT_OPTIONS.merge(options)

    FileUtils.mkdir_p(@options[:path]) unless File.exist? @options[:path]
    `cd #{@options[:path]}; git init` if ! File.exist? @options[:path] + '/.git'
    @repo = Grit::Repo.new(@options[:path])

    @thread = Thread.new do
      Gitjour::Application.serve(@options[:path], SERVICE_NAME, @options[:port])
    end
    at_exit { @thread && @thread.join }
  end

  # This should be called periodically
  def discover(wait = DISCOVER_TIME)
    Gitjour::Application.discover('_git._tcp', wait) do |service|
      next if service.name !~ Regexp.new(SERVICE_NAME)
      next if service.port.to_i == @options[:port].to_i # TODO: and local
      # No-op if we've got it already, since @conspirators is a Set
      @conspirators << Conspirator.new(service.host, service.port, service.name)
    end
  end

  def sync_all
    # TODO: drop conspirators if they shut down their repo
    @conspirators.map{ |s| s.sync(File.dirname(@repo.path)) }
  end

  def conspirators; @conspirators end
end
