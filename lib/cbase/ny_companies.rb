class Cbase::NYCompanies
  attr_reader :permalinks

  def initialize(permalinks)
    @permalinks = permalinks
  end

  def get_ny_companies
    permalinks.each_with_object([]) do |permalink, nycompanies|
      company = Cbase::Company.new(permalink)
      nycompanies << company if company.in_ny?
    end
  end
end