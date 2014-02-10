require_relative "../spec_helper"

describe NYCompanies, vcr: true do
  before do
    @companies = NYCompanies.new
  end
  
  describe "#get_ny_companies (integration test)" do
    it "returns OpenX, since it's in New York" do
      ny_companies = @companies.get_ny_companies(['openx'])
      expect(ny_companies).to eq([@companies.csv_hash(@companies.company_hash('openx'))])
    end

    it "doesn't return KMart, since it's NOT in New York" do
      ny_companies = @companies.get_ny_companies(['kmart'])
      expect(ny_companies).to eq([])
    end
  end

  describe "#get_ny_companies (integration test - avoids JSON parse error)" do
    it "avoids JSON parse error ('unexpected token') with non-NY companies like CarGurus" do
      ny_companies = @companies.get_ny_companies(['cargurus'])
      expect(ny_companies).to eq([])      
    end

    it "avoids JSON parse error ('unexpected token') with NY companies like EmergingCast" do
      ny_companies = @companies.get_ny_companies(['emergingcast'])
      expect(ny_companies).to eq([@companies.csv_hash(@companies.company_hash('emergingcast'))])      
    end   
  end  
end