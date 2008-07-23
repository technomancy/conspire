module Gitjour
  class Application
    class << self
      public :serve, :discover
      def puts(*args); end unless ENV['DEBUG']
    end
  end
end
