#!/usr/bin/env ruby

require 'fileutils'
require 'timeout'

REMOTE = File.expand_path('test/remote')
LOCAL = File.expand_path('test/local')

FileUtils.cd('test')
system "mkdir #{LOCAL}; cd #{LOCAL}; git init"
system "mkdir #{REMOTE}; cd #{REMOTE}; git init"
system "touch #{REMOTE}/.git/git-daemon-export-ok"

at_exit { system "rm -rf #{REMOTE}"; system "rm -rf #{LOCAL}"}

Thread.new do
  system "cd #{REMOTE}
git-daemon --export-all --port=3333 --base-path=#{REMOTE} --base-path-relaxed"
end

sleep 5

Thread.new do
  loop do
    File.open("#{REMOTE}/file", 'a') { |f| f.puts 'line' }
    puts "committing file"
    `cd #{REMOTE}; git add file; git commit -m "message"`
    sleep 0.2
  end
end

begin
  Timeout.timeout(10) do
    loop { `cd #{LOCAL}; git pull --rebase git://localhost:3333/` }
  end
rescue Timeout::Error
  system "wc -l #{LOCAL}/file"
end
