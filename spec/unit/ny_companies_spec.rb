require 'spec_helper'

describe Cbase::NYCompanies do
  let(:company) {double(:company)}

  describe "#get_ny_companies (unit test)" do
    it "returns Viacom, since it's in New York" do 
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
                      "city"=>"New York"}]}.to_json

      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      nycompanies = Cbase::NYCompanies.new(['viacom']).get_ny_companies
      company = Cbase::Company.new('viacom')
      expect(company).to eq(nycompanies[0])
    end

    it "doesn't return McDonald's, since it's NOT in New York" do
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
                      "city"=>"Oak Brook"}]}.to_json

      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      nycompanies = Cbase::NYCompanies.new(['mcdonalds']).get_ny_companies
      expect(nycompanies).to eq([])
    end

    it "successfully accepts just 1 name and no addresses" do
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
                      "city"=>"New York"}]}.to_json

      company.stub(body: comp_json)
      Net::HTTP.stub(:get_response).and_return(company)
      nycompanies = Cbase::NYCompanies.new(['no-name-company']).get_ny_companies
      company = Cbase::Company.new('no-name-company')
      expect(company).to eq(nycompanies[0])
    end
  end
end