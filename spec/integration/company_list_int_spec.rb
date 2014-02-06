require_relative "../spec_helper"

describe CompanyList, vcr: true do
  # integration test
  before do
    @client = CompanyList.new
  end
  
  describe "#get_company_permalinks (integration test)" do
    it "returns all company permalinks" do
      permalinks = @client.get_company_permalinks
      expect(permalinks[0]).to eq("wetpaint")
      expect(permalinks[1]).to eq("adventnet")  
    end
  end
end