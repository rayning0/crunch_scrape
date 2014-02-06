require_relative "../spec_helper"

describe NYCompanies, vcr: true do
  # integration test
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
end