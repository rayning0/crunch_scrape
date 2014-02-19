require "spec_helper"

describe Cbase::Companies, vcr: true do
  describe "#add_companies_for(city, dbase)" do
    before do
      Cbase::CsvFile.delete_file if Cbase::CsvFile.exists? 
      Cbase::Dbase.delete_db if Cbase::Dbase.exists?
      Cbase::CsvFile.make_csv_header(Cbase::Company::HEADER)
      @dbase = Cbase::Dbase.setup(Cbase::Companies::CREATE_TABLE, Cbase::Companies::CREATE_INDEX)
      @permalinks = ['wetpaint', 'kmart', 'viacom', 'mcdonalds', 'facebook', 'zwinky', 'headstrong-brain-gym', 'uncle-sams-new-york-llc', 'philo-media', 'cargurus', 'emergingcast']
      @ny_companies = ["Wetpaint", "Viacom", "Facebook", "Zwinky", "HeadStrong Brain Gym", "Uncle Sam's New York LLC", "Philo Media", "EmergingCast"]
    end

    it "adds only New York companies to CSV file" do
      Cbase::Companies.new(@permalinks).add_companies_for("New York", @dbase)
      nycompanies = []
      CSV.foreach(Cbase::CsvFile::PATH, {:headers=>:first_row}) do |row|
        nycompanies << row["Company"]
      end
      expect(nycompanies).to eq(@ny_companies)
    end

    it "adds only New York companies to database" do
      Cbase::Companies.new(@permalinks).add_companies_for("New York", @dbase)
      expect(@dbase.execute("SELECT name FROM companies;").flatten).to eq(@ny_companies)
    end

    it "adds nothing to either CSV file or DB if have no New York companies" do
      Cbase::Companies.new(['kmart', 'mcdonalds', 'cargurus']).add_companies_for("New York", @dbase)
      last_line = IO.readlines(Cbase::CsvFile::PATH).last  
      expect(CSV.parse(last_line).first).to eq(Cbase::Company::HEADER)
      expect(@dbase.execute("SELECT name FROM companies;").flatten).to eq([])
    end

    it "adds nothing to CSV file if there are no permalinks" do
      Cbase::Companies.new([]).add_companies_for("New York", @dbase)
      last_line = IO.readlines(Cbase::CsvFile::PATH).last  
      expect(CSV.parse(last_line).first).to eq(Cbase::Company::HEADER)
    end

    it "adds nothing to DB if there are no permalinks" do
      Cbase::Companies.new([]).add_companies_for("New York", @dbase)
      expect(@dbase.execute("SELECT name FROM companies;").flatten).to eq([])
    end
  end
end