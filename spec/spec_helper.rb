require 'bundler/setup'
Bundler.setup

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
end

require 'dotenv'
Dotenv.load

require 'coveralls'
Coveralls.wear!

require 'answers-ruby-client'

RSpec.configure do |config|
end