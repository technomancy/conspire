module Gitjour
  class Application
    class << self
      def start(path, name, port)
        init path
        @thread = Thread.new { Gitjour::Application.start(path, name, port) }
      end

      def init(path)
        FileUtils.mkdir_p(path) unless File.exist? path
        `cd #{path}; git init` if ! File.exist? path + '/.git'
        `touch #{path}/.git/git-daemon-export-ok`
      end

      public :discover
      def puts(*args); end unless ENV['DEBUG']
    end
  end
end
