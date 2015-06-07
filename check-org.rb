require 'octokit'
require 'optparse'

require_relative 'lib/reporters/console_reporter'
require_relative 'lib/signatures'
require_relative 'lib/watcher'

# Initialize options
options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: watch.rb [options]'

  opts.on('-l', '--login NAME', 'github username') { |v| options[:login] = v }
  opts.on('-t', '--token TOKEN', 'github auth token') { |v| options[:password] = v }
  opts.on('-n', '--number NUM', 'number of events to load per user') { |v| options[:number_of_events] = v }
  opts.on('-o', '--organization NAME', 'organization to monitor') { |v| options[:org] = v }
  opts.on('-f', '--from ID', 'only look at events since this id') { |v| options[:from] = v }
end.parse!

# Initialize signatures
sigs = Signatures.new
sigs << { part: :patch, content: /password/ }
sigs << { part: :patch, content: /AWS_SECRET_KEY/ }
sigs << { part: :patch, content: /secret/ }
sigs << { part: :patch, content: /PRIVATE/ }

# Setup client
client = Octokit::Client.new(login: options[:login], password: options[:password])
puts "Rate limit #{client.rate_limit.remaining} remaining of #{client.rate_limit.limit}"

# Watch for bad stuff!
watcher = Watcher.new(client, options[:org], sigs, ConsoleReporter.new)
max = watcher.watch(options[:from].to_i, (options[:number_of_events] || 0).to_i)

puts "Largest id: #{max}"
