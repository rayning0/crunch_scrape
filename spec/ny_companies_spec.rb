require 'spec_helper'

describe NYCompanies do
  before do
    @companies = NYCompanies.new
  end

  describe "#get_ny_companies (unit test)" do
    it "returns Viacom, since it's in New York" do
      company = double(:company) 
      comp_json = {"name"=>"Viacom",
                   "permalink"=>"viacom",
                   "homepage_url"=>"http://www.viacom.com",
                   "email_address"=>"",
                   "phone_number"=>"(212) 258-6000",
                   "relationships"=>
                    [{"is_past"=>false,
                      "title"=>"President, CEO",
                      "person"=>
                       {"first_name"=>"Philippe",
                        "last_name"=>"Dauman",
                        "permalink"=>"philippe-dauman"}},
                     {"is_past"=>false,
                      "title"=>"Senior Exec. VP, Chief Admin. Officer, CFO",
                      "person"=>
                       {"first_name"=>"Thomas",
                        "last_name"=>"Dooley",
                        "permalink"=>"thomas-dooley"}},
                     {"is_past"=>false,
                      "title"=>"VP, Business Development",
                      "person"=>
                       {"first_name"=>"Scott",
                        "last_name"=>"Saperstein",
                        "permalink"=>"scott-saperstein"}}],
                   "offices"=>
                    [{"description"=>"HQ",
                      "address1"=>"1515 Broadway",
                      "address2"=>"",
                      "zip_code"=>"10036",
                      "city"=>"New York",
                      "state_code"=>"NY",
                      "country_code"=>"USA",
                      "latitude"=>40.757725,
                      "longitude"=>-73.986011}]}.to_json

      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      ny_companies = @companies.get_ny_companies(['viacom'])
      
      expect(ny_companies).to eq([@companies.csv_hash(JSON.parse(company.body))])
    end

    it "doesn't return McDonald's, since it's NOT in New York" do
      company = double(:company) 
      comp_json = {"name"=>"McDonald's",
                   "permalink"=>"mcdonalds",
                   "homepage_url"=>"http://www.mcdonalds.com",
                   "email_address"=>"",
                   "phone_number"=>"",
                   "relationships"=>
                    [{"is_past"=>false,
                      "title"=>"Executive Vice President",
                      "person"=>
                       {"first_name"=>"Jeffrey",
                        "last_name"=>"B. Kindler",
                        "permalink"=>"jeffrey-b-kindler"}},
                     {"is_past"=>false,
                      "title"=>"Director",
                      "person"=>
                       {"first_name"=>"Susan",
                        "last_name"=>"Arnold",
                        "permalink"=>"susan-arnold"}},
                     {"is_past"=>false,
                      "title"=>"Director",
                      "person"=>
                       {"first_name"=>"Robert",
                        "last_name"=>"A. Eckert",
                        "permalink"=>"robert-a-eckert"}}],
                   "offices"=>
                    [{"description"=>"Corporate Headquarters",
                      "address1"=>"2111 McDonald's Dr.",
                      "address2"=>"",
                      "zip_code"=>"60523",
                      "city"=>"Oak Brook",
                      "state_code"=>"IL",
                      "country_code"=>"USA",
                      "latitude"=>nil,
                      "longitude"=>nil}]}.to_json

      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      ny_companies = @companies.get_ny_companies(['mcdonalds'])

      expect(ny_companies).to eq([])
    end
  end
end