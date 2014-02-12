require "spec_helper"

describe Cbase::CompanyList, vcr: true do
  before do
    @client = Cbase::CompanyList.new
  end
  
  describe "#get_company_permalinks (integration test)" do
    it "returns all company permalinks" do
      permalinks = @client.get_company_permalinks
      expect(permalinks[0]).to eq("reklamface")
      expect(permalinks[1]).to eq("iab-trkiye")  
    end
  end
end