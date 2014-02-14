require 'sqlite3'
require 'rspec'
require 'vcr'
require 'net/http'
require 'json'
require 'csv'
require 'open-uri'
require 'pry'

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end

# VCR setup
VCR.configure do |c|
  c.cassette_library_dir = './spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes}
  c.allow_http_connections_when_no_cassette = true
end

# pull in the code to test
require "#{File.dirname(__FILE__)}/../lib/cbase"
