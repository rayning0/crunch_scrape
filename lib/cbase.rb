$LOAD_PATH.unshift(File.expand_path('../.') + "/crunch_scrape/lib")
PERMALINK_PATH = File.expand_path('../.') + "/crunch_scrape/data/permalinks.txt"

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
  exit
end

city = ARGV[0]
argr, argd = false, false
ARGV[1..2].each do |arg|
  arg = arg.downcase
  if !arg.nil?
    argd = true if arg.downcase.include?("d")
    argr = true if arg.downcase.include?("r")
  end
end

if !File.exist?(PERMALINK_PATH)
  permalinks = Cbase::Client.new.company_permalinks.sort
  file = File.open(PERMALINK_PATH, 'w')
  file.puts permalinks
  file.close
end

#read file as array
#permalinks = IO.readlines(PERMALINK_PATH).map(&:chomp)

PERMALINKS = ['wetpaint', 'kmart', 'viacom', 'mcdonalds', 'facebook', 'zwinky', 'headstrong-brain-gym', 'uncle-sams-new-york-llc', 'philo-media', 'cargurus', 'emergingcast']

Cbase::Companies.new(PERMALINKS).add_companies_for(city)