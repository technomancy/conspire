module Gitjour
  class Application
    class << self
      public :discover, :serve

      def init(path)
        abort "Repository already exists: #{path}" if File.exist? path + '/.git'
        at_exit { FileUtils.rm_rf path + '/.git' } unless ENV['KEEP']
        `mkdir -p #{path} && cd #{path} && git init`
        `touch #{path}/.git/git-daemon-export-ok`
      end

      def puts(*args); end unless ENV['DEBUG']
    end
  end
end
