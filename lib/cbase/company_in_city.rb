class Cbase::CompanyInCity
  attr_accessor :fcity
  attr_reader :name, :permalink, :phone, :offices, :email

  HEADER = ["Company", "Website", "Phone", "Address", "Email", "Team Page", "Person 1", "Job 1", "Person 2", "Job 2", "Person 3", "Job 3"]

  NO_PERSON = {"title" => nil, "person" => {"first_name" => nil, "last_name" => nil}}

  def initialize(company, fcity)
    @name = company.name
    @permalink = company.permalink
    @phone = company.phone
    @offices = company.offices
    @fcity = fcity
    @email = company.email
    @url = company.url
    @people = company.people[0..2]
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
    offices.map{|office| office["city"]}.include?(fcity)
  end

  def address
    if in_city?
      off = offices.select {|office| office["city"].downcase == fcity.downcase}.first
      "#{off["address1"]} #{off["address2"]} #{off["city"]}"
    end
  end

  def top_people
    @people.map {|person| person.nil? ? NO_PERSON : person}
  end

  def person
    top_people.map {|p| "#{p["person"]["first_name"]} #{p["person"]["last_name"]}"}
  end

  def job
    top_people.map {|person| person["title"]}
  end

  def attributes
    [name, url, phone, address, email, mgmt_team, 
     person[0], job[0], person[1], job[1], person[2], job[2]]
  end

  def to_csv
    Cbase::CsvFile.new(attributes).to_csv
  end
end