require_relative "./cbase/version"
require_relative "./cbase/client"
require_relative "./cbase/csv_file"
require_relative "./cbase/company"
require_relative "./cbase/companies"

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
#companies = Companies.new(permalinks).companies_in(city)

PERMALINKS = ['wetpaint', 'kmart', 'viacom', 'mcdonalds', 'facebook', 'zwinky', 'headstrong-brain-gym', 'uncle-sams-new-york-llc', 'philo-media', 'cargurus', 'emergingcast']

companies = Cbase::Companies.new(PERMALINKS).companies_in(city)
Cbase::CsvFile.new(companies).to_csv