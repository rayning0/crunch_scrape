require 'spec_helper'

describe Company do
  let(:company) {double(:company)}

  let(:comp_json) do
    {"name"=>"Viacom",
    "permalink"=>"viacom",
    "homepage_url"=>"http://www.viacom.com",
    "email_address"=>"",
    "phone_number"=>"(212) 258-6000",
    "relationships"=>
      [{"title"=>"President, CEO",
        "person"=>
         {"first_name"=>"Philippe",
          "last_name"=>"Dauman"}},
       {"title"=>"Senior Exec. VP, Chief Admin. Officer, CFO",
        "person"=>
         {"first_name"=>"Thomas",
          "last_name"=>"Dooley"}},
       {"title"=>"VP, Business Development",
        "person"=>
         {"first_name"=>"Scott",
          "last_name"=>"Saperstein"}}],
    "offices"=>
      [{"address1"=>"1515 Broadway",
        "address2"=>"",
        "city"=>"New York"}]}.to_json
  end

  describe "#company_hash (unit test)" do
    it "returns hash of a company's data" do
      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      chash = Company.new('viacom').company_hash
      expect(chash).to eq(JSON.parse(company.body))
    end
  end

  describe "#get_ny_address (unit test)" do
    it "returns NY address of a company" do
      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      nyaddress = Company.new('viacom').get_ny_address
      expect(nyaddress).to eq("1515 Broadway  New York")
    end
  end

  describe "#in_ny? (unit test)" do
    it "returns true/false if a company has a NY office" do
      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      expect(Company.new('viacom').in_ny?).to eq(true)
    end
  end
end