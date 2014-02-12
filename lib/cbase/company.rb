class Cbase::Company
  attr_reader :permalink, :name, :url, :phone, :offices, :nyaddress, 
              :email, :mgmt_team, :person, :job

  NO_PERSON = {"title" => nil, "person" => {"first_name" => nil, "last_name" => nil}}

  def initialize(permalink)
    @permalink = permalink
    company = company_hash

    @name = company["name"]
    @url = "=HYPERLINK(\"#{company["homepage_url"]}\")"
    @phone = company["phone_number"]
    @offices = company["offices"]
    @nyaddress = get_ny_address
    @email = company["email_address"]
    @mgmt_team = "=HYPERLINK(\"https://www.google.com/search?q='management+team'+#{permalink}\")"

    top = company["relationships"][0..2].map {|person| person.nil? ? NO_PERSON : person}
    @person = top[0..2].map {|p| "#{p["person"]["first_name"]} #{p["person"]["last_name"]}"}
    @job = top[0..2].map {|p| p["title"]}
  end

  def ==(other)
    permalink == other.permalink &&
      name == other.name &&
      url == other.url &&
      phone == other.phone &&
      offices == other.offices &&
      nyaddress == other.nyaddress &&
      email == other.email &&
      person[0] == other.person[0] &&
      person[1] == other.person[1] &&
      person[2] == other.person[2] &&
      job[0] == other.job[0] &&
      job[1] == other.job[1] &&
      job[2] == other.job[2]
  end

  def company_hash
    company_url = "http://api.crunchbase.com/v/1/company/#{permalink}.js?api_key=#{Cbase::CompanyList::API_KEY}"
    response = Net::HTTP.get_response(URI(company_url))
    
    # Prevent JSON parse error ("unexpected token")
    response = response.body.gsub(/(?<=\"overview\"\:)(.*)(?=\,\n\s\"image\"\:)/, "null")
    JSON.parse(response)
  end 

  def get_ny_address
    if in_ny?
      ny = offices.select {|office| office["city"] == "New York"}[0]
      "#{ny["address1"]} #{ny["address2"]} New York"
    end
  end

  def in_ny?
    offices.map{|office| office["city"]}.include?("New York")
  end
end