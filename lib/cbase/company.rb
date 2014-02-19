class Cbase::Company
  attr_reader :name, :permalink, :phone, :offices, :email, :url, :people

  def initialize(comp_hash)
    @name = comp_hash["name"]
    @permalink = comp_hash["permalink"]
    @phone = comp_hash["phone_number"]
    @offices = comp_hash["offices"]
    @email = comp_hash["email_address"]
    @url = comp_hash["homepage_url"]
    @people = comp_hash["relationships"]
  end
end