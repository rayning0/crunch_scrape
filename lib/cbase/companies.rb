class Cbase::Companies
  attr_reader :permalinks

  def initialize(permalinks)
    @permalinks = permalinks
  end

  def companies_in(city)
    permalinks.each_with_object([]) do |permalink, companies|
      comp_hash = Cbase::Client.new(permalink).company_hash
      comp_hash["city"] = city
      company = Cbase::Company.new(comp_hash)
      companies << company if company.in_city?
    end
  end
end