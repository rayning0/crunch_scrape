class CompanyList
  def get_company_permalinks
    get_companies.map {|company| company["permalink"]}
  end

  def get_companies
    response = Net::HTTP.get_response(URI(COMPANIES_URL))
    JSON.parse(response.body)
  end

  private
  API_KEY = "an35bya6x7ktkm5z7q3q6dvg"
  COMPANIES_URL = "http://api.crunchbase.com/v/1/companies.js?api_key=#{API_KEY}"
end