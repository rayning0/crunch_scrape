class Cbase::Client
  attr_reader :permalink

  def initialize(permalink = nil)
    @permalink = permalink
  end

  def company_permalinks
    all_companies.map {|company| company["permalink"]}
  end

  def company_hash
    company_url = "http://api.crunchbase.com/v/1/company/#{permalink}.js?api_key=#{API_KEY}"
    response = Net::HTTP.get_response(URI(company_url))
    
    # Prevent JSON parse error ("unexpected token")
    response = response.body.gsub(/(?<=\"overview\"\:)(.*)(?=\,\n\s\"image\"\:)/, "null")
    JSON.parse(response)
  end 

  private

  def all_companies
    response = Net::HTTP.get_response(URI(COMPANIES_URL))
    # gsub is temporary fix for CrunchBase typo in data
    JSON.parse(response.body.gsub("][", ",\n "))
  end

  API_KEY = "an35bya6x7ktkm5z7q3q6dvg"
  COMPANIES_URL = "http://api.crunchbase.com/v/1/companies.js?api_key=#{API_KEY}"
end