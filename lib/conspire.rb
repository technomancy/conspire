$LOAD_PATH << File.dirname(__FILE__)
require 'set'
require 'rubygems'
require 'gitjour'
require 'mojombo-grit'

require 'conspire/gitjour_exts'
require 'conspire/conspirator'

module Conspire
  VERSION = '0.0.1'
  DEFAULT_OPTIONS = { :port => 7456, :path => Dir.pwd }
  SERVICE_NAME = 'conspire'

  @conspirators = Set.new

  module_function

  def start(options = {})
    options = DEFAULT_OPTIONS.merge(options)
    @repo = Grit::Repo.new(options[:path])
    @thread = Thread.new do
      Gitjour::Application.serve(options[:path], SERVICE_NAME, options[:port])
    end
    at_exit { @thread.join }
  end

  def discover
    Gitjour::Application.service_list('_git._tcp').each do |service|
      next unless service.name == SERVICE_NAME
      # No-op if we've got it already, since @conspirators is a Set
      @conspirators << Conspirator.new(service.host, service.port)
    end
  end

  def sync_all
    @conspirators.map{ |s| s.sync(@repo.path) }
  end

  def conspirators; @conspirators end
end
