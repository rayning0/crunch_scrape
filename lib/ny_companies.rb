class NYCompanies
  NO_PERSON = {"title" => nil, "person" => {"first_name" => nil, "last_name" => nil}}

  def get_ny_companies(permalinks)
    permalinks.map {|permalink|
      company = company_hash(permalink) 
      csv_hash(company) if in_ny?(company)
    }.compact
  end

  def company_hash(permalink)
    company_url = "http://api.crunchbase.com/v/1/company/#{permalink}.js?api_key=#{CompanyList::API_KEY}"
    begin
      response = Net::HTTP.get_response(URI(company_url))
      
      # Prevent JSON parse error ("unexpected token")
      response = response.body.gsub(/(?<=\"overview\"\:)(.*)(?=\,\n\s\"image\"\:)/, "null")
      comp_hash = JSON.parse(response)
    rescue StandardError => e
      $stderr.puts permalink
      $stderr.puts e.message
      $stderr.puts e.backtrace.inspect
    end
    comp_hash
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
    offices.map { |office|
      if office["city"] == "New York"
        "=HYPERLINK(\"https://www.google.com/maps/preview/place/'#{office["address1"]} #{office["address2"]} New York'\")"  
      end
    }.compact.first
  end

  def in_ny?(company)
    company["offices"].each do |office|
      return true if office["city"] == "New York"
    end
    false
  end
end