class Cbase::Company
  attr_reader :company, :name, :permalink, :phone, :offices, :city, :email

  NO_PERSON = {"title" => nil, "person" => {"first_name" => nil, "last_name" => nil}}

  def initialize(company)
    @name = company["name"]
    @permalink = company["permalink"]
    @phone = company["phone_number"]
    @offices = company["offices"]
    @city = company["city"]
    @email = company["email_address"]
    @url = company["homepage_url"]
    @people = company["relationships"][0..2]
  end

  def ==(other)
    name == other.name &&
      permalink == other.permalink &&
      url == other.url &&
      phone == other.phone &&
      offices == other.offices &&
      address == other.address &&
      email == other.email &&
      person[0] == other.person[0] &&
      person[1] == other.person[1] &&
      person[2] == other.person[2] &&
      job[0] == other.job[0] &&
      job[1] == other.job[1] &&
      job[2] == other.job[2]
  end

  def url
    "=HYPERLINK(\"#{@url}\")"
  end

  def mgmt_team
    "=HYPERLINK(\"https://www.google.com/search?q='management+team'+#{permalink}\")"
  end

  def in_city?
    offices.map{|office| office["city"]}.include?(city)
  end

  def address
    if in_city?
      off = offices.select {|office| office["city"] == city}[0]
      "#{off["address1"]} #{off["address2"]} #{city}"
    end
  end

  def top_people
    @people[0..2].map {|person| person.nil? ? NO_PERSON : person}
  end

  def person
    top_people[0..2].map {|p| "#{p["person"]["first_name"]} #{p["person"]["last_name"]}"}
  end

  def job
    top_people[0..2].map {|person| person["title"]}
  end
end