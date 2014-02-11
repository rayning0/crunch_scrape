require_relative "version"
require_relative "company_list"
require_relative "csv_file"
require_relative "company"
require_relative "ny_companies"

require 'net/http'
require 'json'
require 'csv'
require 'open-uri'
require 'pry'

#permalinks = CompanyList.new.get_company_permalinks
#nycompanies = NYCompanies.new(permalinks).get_ny_companies

# PERMALINKS = ['wetpaint', 'kmart', 'viacom', 'mcdonalds', 'facebook', 
#   'zwinky', 'headstrong-brain-gym', 'uncle-sams-new-york-llc', 'philo-media',
#   'cargurus', 'emergingcast']

# nycompanies = NYCompanies.new(PERMALINKS).get_ny_companies
# CsvFile.new(nycompanies).to_csv