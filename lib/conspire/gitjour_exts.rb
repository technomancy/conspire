module Gitjour
  class Application
    class << self
      public :discover, :serve

      def init(path)
        abort "Repository already exists: #{path}" if File.exist? path + '/.git'
        `mkdir -p #{path} && cd #{path} && git init`
        `touch #{path}/.git/git-daemon-export-ok`
      end

      def puts(*args); end unless ENV['DEBUG']
    end
  end
end
