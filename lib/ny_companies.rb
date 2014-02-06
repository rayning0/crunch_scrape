class NYCompanies
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
      comp_hash = JSON.parse(response.body)
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
    begin
      comp[:url] = "=HYPERLINK(\"#{company["homepage_url"]}\")"
      comp[:phone] = company["phone_number"]

      comp[:address] = get_ny_address(company["offices"])

      comp[:email] = company["email_address"]
      comp[:mgmt_team] = "=HYPERLINK(\"https://www.google.com/search?q='management+team'+#{company["permalink"]}\")"
      top1, top2, top3 = company["relationships"][0..2]

      comp[:person1] = "#{top1["person"]["first_name"]} #{top1["person"]["last_name"]}"
      comp[:person2] = "#{top2["person"]["first_name"]} #{top2["person"]["last_name"]}"
      comp[:person3] = "#{top3["person"]["first_name"]} #{top3["person"]["last_name"]}" 
      comp[:job1] = top1["title"]
      comp[:job2] = top2["title"]
      comp[:job3] = top3["title"]
    rescue StandardError => e
      $stderr.puts company["permalink"]
      $stderr.puts e.message
      $stderr.puts e.backtrace.inspect
    end
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