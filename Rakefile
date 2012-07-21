require 'rubygems'
require 'open3'
require 'talks'

task :test do
 stdin, stdout, stderr = Open3.popen3 \
    './node_modules/mocha/bin/mocha ./spec/*_spec.coffee --compilers coffee:coffee-script -R spec -c'

  puts stdout_array = stdout.readlines
  puts stderr_array = stderr.readlines

  stdout_strings = stdout_array.to_s
  stderr_strings = stderr_array.to_s

  if stderr_strings and
    error_match = stderr_strings.match(/(\d+) of (\d+) tests failed/)

    failed_count, total_count = error_match.captures

    message = "#{failed_count} of #{total_count} tests failed"

  elsif stdout_strings_match = stdout_strings.match(/(\d+) tests complete/)
    complete_count, = stdout_strings_match.captures

    if pending_matches = stdout_strings.match(/(\d+) tests pending/)
      pending_count, = pending_matches.captures
    end

    message = "#{complete_count} tests complete"
    message += ", #{pending_count} tests pending" if pending_count

  else
    message = 'Something wrong, check console output.'
  end

  Talks.say message, notify: true, detach: true
end