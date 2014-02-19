require 'spec_helper'

describe Cbase::Company do
  let(:comp_hash) do
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
        "city"=>"New York"},
       {"address1"=>"100 Main St",
        "address2"=>"Suite 25",
        "city"=>"Los Angeles"}]}
  end

  let!(:company) {Cbase::Company.new(comp_hash)}
  let(:attributes) {["Viacom",
         "=HYPERLINK(\"http://www.viacom.com\")",
         "(212) 258-6000",
         nil,
         "",
         "=HYPERLINK(\"https://www.google.com/search?q='management+team'+viacom\")",
         "Philippe Dauman",
         "President, CEO",
         "Thomas Dooley",
         "Senior Exec. VP, Chief Admin. Officer, CFO",
         "Scott Saperstein",
         "VP, Business Development"]}

  describe "#==" do
    it "returns true if 2 company objects have same attributes" do
      company2 = Cbase::Company.new(comp_hash)
      expect(company).to eq(company2)
    end

    it "returns false if 2 company objects have different attributes" do
      comp_hash["name"] = "McDonald's"
      company2 = Cbase::Company.new(comp_hash)
      expect(company).to_not eq(company2)
    end
  end

  describe "#url" do
    it "returns url" do
      expect(company.url).to eq("=HYPERLINK(\"http://www.viacom.com\")")
    end
  end

  describe "#mgmt_team" do
    it "returns management team" do
      expect(company.mgmt_team).to eq("=HYPERLINK(\"https://www.google.com/search?q='management+team'+viacom\")")
    end
  end

  describe "#in_city?" do
    it "returns true if company has an office in chosen city" do
      comp_hash["filter_city"] = "New York"
      company = Cbase::Company.new(comp_hash)
      expect(company.in_city?).to eq(true)
    end

    it "returns false if company has no office in chosen city" do
      comp_hash["filter_city"] = "London"
      company = Cbase::Company.new(comp_hash)
      expect(company.in_city?).to eq(false)
    end
  end  

  describe "#address" do
    it "returns address of company, for office in chosen city" do
      comp_hash["filter_city"] = "Los Angeles"
      company = Cbase::Company.new(comp_hash)
      expect(company.address).to eq("100 Main St Suite 25 Los Angeles")
    end

    it "returns nil if company has no office in chosen city" do
      comp_hash["filter_city"] = "Beijing"
      company = Cbase::Company.new(comp_hash)
      expect(company.address).to eq(nil)
    end
  end

  describe "#top_people" do
    it "returns info for top 3 people at company" do
      expect(company.top_people).to eq([{"title"=>"President, CEO",
          "person"=>{"first_name"=>"Philippe", "last_name"=>"Dauman"}},
         {"title"=>"Senior Exec. VP, Chief Admin. Officer, CFO",
          "person"=>{"first_name"=>"Thomas", "last_name"=>"Dooley"}},
         {"title"=>"VP, Business Development",
          "person"=>{"first_name"=>"Scott", "last_name"=>"Saperstein"}}])
    end

    it "returns info for top 1 person at company, if only 1 person given" do
      comp_hash["relationships"] = [{"title"=>"Top Dog",
          "person"=>{"first_name"=>"Raymond", "last_name"=>"Gan"}}]
      company = Cbase::Company.new(comp_hash)
      expect(company.top_people).to eq([{"title"=>"Top Dog",
          "person"=>{"first_name"=>"Raymond", "last_name"=>"Gan"}}])
    end

    it "returns [] if no top people given for company" do
      comp_hash["relationships"] = []
      company = Cbase::Company.new(comp_hash)
      expect(company.top_people).to eq([])
    end
  end

  describe "#job" do
    it "returns jobs for top 3 people at company" do
      expect(company.job).to eq(["President, CEO", "Senior Exec. VP, Chief Admin. Officer, CFO", "VP, Business Development"])
    end

    it "returns job for top 1 person at company, if only 1 person given" do
      comp_hash["relationships"] = [{"title"=>"Top Dog",
          "person"=>{"first_name"=>"Raymond", "last_name"=>"Gan"}}]
      company = Cbase::Company.new(comp_hash)
      expect(company.job).to eq(["Top Dog"])
    end

    it "returns [] for jobs if no top people given for company" do
      comp_hash["relationships"] = []
      company = Cbase::Company.new(comp_hash)
      expect(company.job).to eq([])
    end
  end

  describe "#attributes" do
    it "returns main attributes for company" do
      expect(company.attributes).to eq(attributes)
    end
  end

  describe "#to_csv" do
    it "adds 1 row to CSV file for each company" do
      company.to_csv
      last_line = IO.readlines(Cbase::CsvFile::PATH).last  
      expect(CSV.parse(last_line).first).to eq(attributes)
    end
  end
end