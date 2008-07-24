module Gitjour
  class Application
    class << self
      def init(path)
        FileUtils.mkdir_p(path) unless File.exist? path
        `cd #{path}; git init` if ! File.exist? path + '/.git'
        `touch #{path}/.git/git-daemon-export-ok`
      end

      public :discover, :serve
      def puts(*args); end unless ENV['DEBUG']
    end
  end
end
