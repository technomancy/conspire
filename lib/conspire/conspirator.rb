module Conspire
  class Conspirator
    attr_accessor :last_synced

    def initialize(host, port)
      @host, @port = remote.split(':')
      @port ||= DEFAULT_OPTIONS[:port]
    end

    def to_s
      "#{@host}:#{@port}"
    end

    def sync(path)
      `cd #{path} && git pull #{url}`
      @last_synced = Time.now
    end

    def url; "git://#{@host}:#{@port}/conspire" end

    def eql?(other)
      self.to_s == other.to_s
    end
  end
end
