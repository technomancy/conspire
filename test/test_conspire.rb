require 'rubygems'
begin
  gem 'miniunit'
rescue LoadError; end

require 'test/unit'
require 'fileutils'
require File.dirname(__FILE__) + '/../lib/conspire'

REMOTE_SPACE = File.dirname(__FILE__) + '/remote-space'
LOCAL_SPACE = File.dirname(__FILE__) + '/local-space'

module Conspire
  def self.reset!
    @conspirators = []
    @thread && @thread.kill
  end
end

class TestConspire < Test::Unit::TestCase
  def setup
    FileUtils.mkdir_p(REMOTE_SPACE)
    File.open(REMOTE_SPACE + '/file', 'w') { |f| f.puts "hello world." }
    `cd #{REMOTE_SPACE}; git init; git add file; git commit -m "init"`

    FileUtils.mkdir_p(LOCAL_SPACE)
    `cd #{LOCAL_SPACE}; git init`

    @remote_thread = Thread.new do
      Gitjour::Application.serve(REMOTE_SPACE, Conspire::SERVICE_NAME, 7458)
    end

    Conspire.start(:port => 7457,
                   :path => "#{File.dirname(__FILE__)}/local-space")
    Conspire.discover
  end

  def teardown
    FileUtils.rm_rf(REMOTE_SPACE)
    FileUtils.rm_rf(LOCAL_SPACE)
    @remote_thread.kill
    Conspire.reset!
  end

  def test_start
    assert_equal ['localhost:7458'], Conspire.conspirators.map{ |s| s.to_s }
  end

  def test_subscribe
    assert_equal ['file'], Conspire.files.map{ |f| f.name }
  end

  def test_commit
  end

  def test_rebase
  end
end
