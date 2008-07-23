require 'rubygems'
begin
  gem 'miniunit' # just fer kicks...
rescue LoadError; end

require 'test/unit'
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

    @remote_thread = Thread.new do
      Gitjour::Application.serve(REMOTE_SPACE, Conspire::SERVICE_NAME, 7458)
    end

    Conspire.start(:port => 7457, :path => LOCAL_SPACE)
    Conspire.discover
  end

  def teardown
    @remote_thread.kill
    Conspire.reset!
    FileUtils.rm_rf(REMOTE_SPACE)
    FileUtils.rm_rf(LOCAL_SPACE)
  end

  def test_discover
    assert_equal ['localhost:7458'], Conspire.conspirators.map{ |s| s.to_s }
  end

  def test_sync
    Conspire.sync_all
    assert_equal ['file'], Dir.glob("#{LOCAL_SPACE}/*")
  end

  def test_commit
  end

  def test_rebase
  end
end
