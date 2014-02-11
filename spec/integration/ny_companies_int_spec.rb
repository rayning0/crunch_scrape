require_relative "../spec_helper"

describe NYCompanies, vcr: true do
  
  describe "#get_ny_companies (integration test)" do
    it "returns OpenX, since it's in New York" do
      nycompanies = NYCompanies.new(['openx']).get_ny_companies
      expect(Company.new('openx')).to eq(nycompanies[0])
    end

    it "doesn't return KMart, since it's NOT in New York" do
      nycompanies = NYCompanies.new(['kmart']).get_ny_companies
      expect(nycompanies).to eq([])
    end
  end

  describe "#get_ny_companies (integration test - avoids JSON parse error)" do
    it "avoids JSON parse error ('unexpected token') with non-NY companies like CarGurus" do
      nycompanies = NYCompanies.new(['cargurus']).get_ny_companies
      expect(nycompanies).to eq([])      
    end

    it "avoids JSON parse error ('unexpected token') with NY companies like EmergingCast" do
      nycompanies = NYCompanies.new(['emergingcast']).get_ny_companies
      expect(Company.new('emergingcast')).to eq(nycompanies[0])      
    end   
  end  
end