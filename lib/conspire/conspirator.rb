module Conspire
  class Conspirator
    attr_accessor :last_synced, :host, :port, :name

    def initialize(host, port, name = SERVICE_NAME)
      @host, @port, @name = host[0 .. -2], port || DEFAULT_OPTIONS[:port], name
    end

    def sync(path)
      # TODO: suppress output
      puts "cd #{path} && git pull --rebase #{url}" if ENV['DEBUG']
      system "cd #{path} && git pull --rebase #{url}" or
        raise "Could not rebase from #{url}"

      @last_synced = Time.now
    end

    def url; "git://#{@host}:#{@port}/" end

    alias_method :to_s, :url
    alias_method :inspect, :url

    # For set equality
    def eql?(other); self.url == other.url end
    def hash; url.hash end
  end
end
