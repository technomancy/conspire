module Conspire
  class Conspirator
    attr_accessor :last_synced, :host, :port, :name

    def initialize(host, port, name = SERVICE_NAME)
      @host, @port, @name = host, port || DEFAULT_OPTIONS[:port], name
    end

    def sync(path)
      # TODO: suppress output
      `cd #{path} && git pull --rebase #{url}`
      @last_synced = Time.now
    end

    def url; "git://#{@host}.local:#{@port}/" end

    alias_method :to_s, :url
    alias_method :inspect, :url

    def eql?(other)
      self.to_s == other.to_s
    end
  end
end
