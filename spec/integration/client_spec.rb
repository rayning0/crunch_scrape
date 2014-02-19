require "spec_helper"

describe Cbase::Client, vcr: true do

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
      permalinks = Cbase::Client.new.company_permalinks.sort
      expect(permalinks[0]).to eq("0nl9")
      expect(permalinks[1]).to eq("0to60")  
      expect(permalinks[2]).to eq("1-800-contacts-2")
    end
  end

  describe "#company_hash" do
    it "returns hash data for 1 company" do 
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