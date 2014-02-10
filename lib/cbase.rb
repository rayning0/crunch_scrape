require_relative "version"
require_relative "company_list"
require_relative "csv_file"
require_relative "ny_companies"

require 'net/http'
require 'json'
require 'csv'
require 'open-uri'
require 'pry'

# #permalinks = CompanyList.new.get_company_permalinks
# PERMALINKS = ['wetpaint', 'kmart', 'viacom', 'mcdonalds', 'facebook', 
#   'zwinky', 'headstrong-brain-gym', 'uncle-sams-new-york-llc', 'philo-media']
# nycompanies = NYCompanies.new.get_ny_companies(PERMALINKS)
# CsvFile.new.to_csv(nycompanies)