$LOAD_PATH.unshift(File.expand_path('../.') + "/crunch_scrape/lib")

require "cbase/version"
require "cbase/client"
require "cbase/csv_file"
require "cbase/company"
require "cbase/companies"
require "cbase/dbase"

require 'sqlite3'
require 'net/http'
require 'json'
require 'csv'
require 'open-uri'
require 'pry'

if ARGV.empty?
  puts "This program creates CSV file of all CrunchBase companies in a city. Use it with these options:\n\n"
  puts "cbase [city name in quotes, like \"New York\"]\n-d (show difference between this run and last)\n-r (disconnected from Internet during last run and want to resume where you left off)\n\n"
  puts "To get all New York City companies, plus both d and r, write: 'cbase \"New York\" -dr'"
  exit 1
end

city = ARGV[0]

#permalinks = Cbase::Client.new.company_permalinks

PERMALINKS = ['wetpaint', 'kmart', 'viacom', 'mcdonalds', 'facebook', 'zwinky', 'headstrong-brain-gym', 'uncle-sams-new-york-llc', 'philo-media', 'cargurus', 'emergingcast']

Cbase::Companies.new(PERMALINKS).add_companies_for(city)