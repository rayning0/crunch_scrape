require 'spec_helper'

describe CompanyList do
  before do
    @client = CompanyList.new
  end

  describe "#get_company_permalinks (unit test)" do
    it "calls Crunchbase API with get_response to get companies" do
      response = double(:response)
      response.stub(body: "[{\"name\": \"Wetpaint\",\n  \"permalink\": \"wetpaint\",\n  \"category_code\": \"web\"},\n {\"name\": \"AdventNet\",\n  \"permalink\": \"adventnet\",\n  \"category_code\": \"enterprise\"}]")
      expect(Net::HTTP).to receive(:get_response).and_return(response)
      @client.get_company_permalinks
    end

    it "returns all company permalinks" do
      response = double(:response) 
      response.stub(body: "[{\"name\": \"Wetpaint\",\n  \"permalink\": \"wetpaint\",\n  \"category_code\": \"web\"},\n {\"name\": \"AdventNet\",\n  \"permalink\": \"adventnet\",\n  \"category_code\": \"enterprise\"}]")

      Net::HTTP.stub(:get_response).and_return(response)
      permalinks = @client.get_company_permalinks
      expect(permalinks).to match_array(["wetpaint", "adventnet"])
    end
  end
end
