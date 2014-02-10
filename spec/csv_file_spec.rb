require 'spec_helper'

describe CsvFile do
  before do
    @csvfile = CsvFile.new
    HEADER = CsvFile::HEADER
    PATH = CsvFile::PATH
    PERMALINKS = ['wetpaint', 'kmart', 'viacom', 'mcdonalds', 'facebook', 
    'zwinky', 'headstrong-brain-gym', 'uncle-sams-new-york-llc', 'philo-media', 
    'cargurus', 'emergingcast']
  end

  describe "#make_CSV_header" do
    it "makes CSV header for a CSV file" do
      @csvfile.make_csv_header
      CSV.foreach(PATH) do |row|
        expect(row).to eq(HEADER)
      end
    end
  end

  describe "#to_csv" do
    it "adds CSV information for only NY companies to file" do
      nycompanies = NYCompanies.new.get_ny_companies(PERMALINKS)
      @csvfile.to_csv(nycompanies)
      CSV.foreach(PATH, {:headers=>:first_row}) do |row|
        expect(row.to_s.include?("New York")).to eq(true)
      end
    end
  end
end 