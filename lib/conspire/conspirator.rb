module Conspire
  class Conspirator
    attr_accessor :last_synced, :host, :port, :name

    def initialize(host, port, name = DEFAULTS[:name])
      @host, @port, @name = host[0 .. -2], port || DEFAULTS[:port], name
    end

    def sync(path)
      # TODO: figure out conflictless rebasing... evan?
      success = if ENV['DEBUG']
                  puts "cd #{path} && git pull --rebase #{url}"
                  system "cd #{path} && git pull --rebase #{url}"
                else
                  system "cd #{path} && git pull --rebase #{url} &> /dev/null"
                end

      raise "could not rebase from #{url}" if ! success
      # @last_synced = Time.now # is this useful?
    end

    def url; "git://#{@host}:#{@port}/" end

    alias_method :to_s, :url

    # For set equality
    def eql?(other); self.url == other.url end
    def hash; url.hash end
  end
end
