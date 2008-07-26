module Gitjour
  class Application
    class << self
      public :discover, :serve

      def init(path)
        abort "Repository already exists: #{path}" if File.exist? path + '/.git'
        
        `mkdir -p #{path} && cd #{path} && git init`
        FileUtils.touch ["#{path}/.git/git-daemon-export-ok", "#{path}/.conspire"]
        `cd #{path}; git add .conspire; git commit -m "initial"`

        at_exit { FileUtils.rm_rf [path + '/.git', path + '/.conspire'] } unless ENV['KEEP']
      end

      def puts(*args); end unless ENV['DEBUG']
    end
  end
end
