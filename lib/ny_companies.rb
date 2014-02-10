class NYCompanies
  NO_PERSON = {"title" => nil, "person" => {"first_name" => nil, "last_name" => nil}}

  def get_ny_companies(permalinks)
    # companies.select{ |c| c.in_ny? }.map { |c| c.csv_hash } 
    permalinks.each_with_object([]) do |permalink, nyc|
      company = company_hash(permalink)
      nyc << csv_hash(company) if in_ny?(company)
    end
  end

  def company_hash(permalink)
    company_url = "http://api.crunchbase.com/v/1/company/#{permalink}.js?api_key=#{CompanyList::API_KEY}"
    response = Net::HTTP.get_response(URI(company_url))
    
    # Prevent JSON parse error ("unexpected token")
    response = response.body.gsub(/(?<=\"overview\"\:)(.*)(?=\,\n\s\"image\"\:)/, "null")
    JSON.parse(response)
  end 

  def csv_hash(company)
    comp = {}
    comp[:name] = company["name"]
    comp[:url] = "=HYPERLINK(\"#{company["homepage_url"]}\")"
    comp[:phone] = company["phone_number"]
    comp[:address] = get_ny_address(company["offices"])
    comp[:email] = company["email_address"]
    comp[:mgmt_team] = "=HYPERLINK(\"https://www.google.com/search?q='management+team'+#{company["permalink"]}\")"

    top = []
    (0..2).each do |i|
      top[i] = company["relationships"][i].nil? ? NO_PERSON : company["relationships"][i]
    end

    comp[:person0] = "#{top[0]["person"]["first_name"]} #{top[0]["person"]["last_name"]}"
    comp[:person1] = "#{top[1]["person"]["first_name"]} #{top[1]["person"]["last_name"]}"
    comp[:person2] = "#{top[2]["person"]["first_name"]} #{top[2]["person"]["last_name"]}" 

    comp[:job0] = top[0]["title"]
    comp[:job1] = top[1]["title"]
    comp[:job2] = top[2]["title"]
    comp
  end

  def get_ny_address(offices)
    ny = offices.select {|office| office["city"] == "New York"}[0]
    "#{ny["address1"]} #{ny["address2"]} New York"
  end

  def in_ny?(company)
    company["offices"].map{|office| office["city"]}.include?("New York")
  end
end