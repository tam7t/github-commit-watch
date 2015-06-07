require 'octokit'

require_relative 'lib/reporters/email_reporter'
require_relative 'lib/signatures'
require_relative 'lib/watcher'

# Initialize options
options = {}
options[:login] = ENV['GITHUB_LOGIN'] || ( raise ArgumentError.new('GITHUB_LOGIN required') )
options[:password] = ENV['GITHUB_PASSWORD'] || ( raise ArgumentError.new('GITHUB_PASSWORD required') )
options[:number_of_events] = ENV['EVENTS']
options[:org] = ENV['GITHUB_ORGANIZATION'] || ( raise ArgumentError.new('GITHUB_ORGANIZATION required') )
options[:mailgun_api_key] = ENV['MAILGUN_TOKEN'] || ( raise ArgumentError.new('MAILGUN_TOKEN required') )
options[:from] = ENV['FROM'] || ( raise ArgumentError.new('FROM required') )
options[:domain] = ENV['DOMAIN'] || ( raise ArgumentError.new('DOMAIN required') )
options[:to] = ENV['TO'] || ( raise ArgumentError.new('TO required') )
options[:subject] = ENV['SUBJECT']

# Initialize signatures
sigs = Signatures.new
sigs << {:part => :patch, :content => /password/}
sigs << {:part => :patch, :content => /AWS_SECRET_KEY/}
sigs << {:part => :patch, :content => /secret/}
sigs << {:part => :patch, :content => /PRIVATE/}

# Setup client
client = Octokit::Client.new(:login => options[:login], :password => options[:password])
from = options[:from].to_i

# Watch for bad stuff!
while true
  puts "Rate limit #{client.rate_limit.remaining} remaining of #{client.rate_limit.limit}"

  watcher = Watcher.new(client, options[:org], sigs, EmailReporter.new(options))

  from = watcher.watch(from, (options[:number_of_events] || 10).to_i)

  sleep(10 * 60)
end