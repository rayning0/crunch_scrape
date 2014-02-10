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
                      "zip_code"=>"10036",
                      "city"=>"New York",
                      "state_code"=>"NY"}]}.to_json

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
                    [{"title"=>"Executive Vice President",
                      "person"=>
                       {"first_name"=>"Jeffrey",
                        "last_name"=>"B. Kindler"}},
                     {"title"=>"Director",
                      "person"=>
                       {"first_name"=>"Susan",
                        "last_name"=>"Arnold"}},
                     {"title"=>"Director",
                      "person"=>
                       {"first_name"=>"Robert",
                        "last_name"=>"A. Eckert"}}],
                   "offices"=>
                    [{"address1"=>"2111 McDonald's Dr.",
                      "address2"=>"",
                      "zip_code"=>"60523",
                      "city"=>"Oak Brook",
                      "state_code"=>"IL"}]}.to_json

      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      ny_companies = @companies.get_ny_companies(['mcdonalds'])

      expect(ny_companies).to eq([])
    end

    it "successfully accepts just 1 name and no addresses" do
      company = double(:company) 
      comp_json = {"name"=>"No Name Company",
                   "permalink"=>"no-name-company",
                   "homepage_url"=>"",
                   "email_address"=>"",
                   "phone_number"=>"",
                   "relationships"=>[{"title"=>"Director",
                                      "person"=>
                                      {"first_name"=>"Susan",
                                       "last_name"=>"Arnold"}}],
                   "offices"=>
                    [{"address1"=>"",
                      "address2"=>"",
                      "city"=>"New York",
                      "state_code"=>""}]}.to_json

      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      ny_companies = @companies.get_ny_companies(['no-name-company'])

      expect(ny_companies).to eq([@companies.csv_hash(JSON.parse(company.body))])
    end
  end
end