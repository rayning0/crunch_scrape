require_relative 'spec_helper'

describe CsvFile do
  describe "#make_CSV_header" do
    it "makes CSV header for a CSV file" do
      CsvFile.new.make_csv_header
      CSV.foreach(CsvFile::PATH) do |row|
        expect(row).to eq(CsvFile::HEADER)
      end
    end
  end

  describe "#to_csv" do
    it "adds CSV information for only NY companies to file" do
      
      permalinks = ['wetpaint', 'kmart', 'viacom', 'mcdonalds', 'facebook', 
      'zwinky', 'headstrong-brain-gym', 'uncle-sams-new-york-llc', 'philo-media', 
      'cargurus', 'emergingcast']

      nycompanies = NYCompanies.new(permalinks).get_ny_companies
      CsvFile.new(nycompanies).to_csv
      CSV.foreach(CsvFile::PATH, {:headers=>:first_row}) do |row|
        expect(row.to_s.include?("New York")).to eq(true)
      end
    end
  end
end 