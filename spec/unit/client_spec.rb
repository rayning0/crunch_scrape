require 'spec_helper'

describe Cbase::Client do 
  let(:response) {double(:response)}

  let(:comp_hash) do
    {"name"=>"Wetpaint",
     "homepage_url"=>"http://wetpaint-inc.com",
     "email_address"=>"info@wetpaint.com",
     "phone_number"=>"206.859.6300",
     "relationships"=>
      [{"title"=>"Co-Founder and VP, Social and Audience Development",
        "person"=>
         {"first_name"=>"Michael"}}],
     "offices"=>
      [{"address1"=>"710 - 2nd Avenue"}]}
  end

  describe "#company_permalinks" do
    it "returns all company permalinks" do 
      response.stub(body: "[{\"name\": \"Wetpaint\",\n  \"permalink\": \"wetpaint\",\n  \"category_code\": \"web\"},\n {\"name\": \"AdventNet\",\n  \"permalink\": \"adventnet\",\n  \"category_code\": \"enterprise\"}]")
      Net::HTTP.stub(:get_response).and_return(response)
      permalinks = Cbase::Client.new.company_permalinks
      expect(permalinks).to match_array(["wetpaint", "adventnet"])
    end
  end

  describe "#company_hash" do
    it "returns hash data for 1 company" do
      response.stub(body: comp_hash.to_json)
      Net::HTTP.stub(:get_response).and_return(response)
      c_hash = Cbase::Client.new("wetpaint").company_hash
      expect(c_hash["name"]).to eq(comp_hash["name"])
      expect(c_hash["homepage_url"]).to eq(comp_hash["homepage_url"])
      expect(c_hash["email_address"]).to eq(comp_hash["email_address"])
      expect(c_hash["phone_number"]).to eq(comp_hash["phone_number"])
      expect(c_hash["relationships"][0]["title"]).to eq(comp_hash["relationships"][0]["title"])
      expect(c_hash["relationships"][0]["person"]["first_name"]).to eq(comp_hash["relationships"][0]["person"]["first_name"])
      expect(c_hash["offices"][0]["address1"]).to eq(comp_hash["offices"][0]["address1"])
    end
  end
end