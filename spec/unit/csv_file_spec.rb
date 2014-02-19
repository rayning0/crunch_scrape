require 'spec_helper'

describe Cbase::CsvFile do
  describe "#make_csv_header" do
    it "makes CSV header for a CSV file" do
      Cbase::CsvFile.make_csv_header(Cbase::CompanyInCity::HEADER)
      first_line = IO.readlines(Cbase::CsvFile::PATH).first  
      expect(CSV.parse(first_line).first).to eq(Cbase::CompanyInCity::HEADER)
    end
  end

  describe "#to_csv" do
    it "adds 1 row to CSV file" do
      attributes = ["Facebook","=HYPERLINK(\"http://www.facebook.com\")","","340 Madison Ave  New York","","=HYPERLINK(\"https://www.google.com/search?q='management+team'+facebook\")","Mark Zuckerberg","Founder and CEO, Board Of Directors","David Ebersman","CFO","Sheryl Sandberg","COO"]

      Cbase::CsvFile.new(attributes).to_csv
      last_line = IO.readlines(Cbase::CsvFile::PATH).last  
      expect(CSV.parse(last_line).first).to eq(attributes)
    end
  end

  describe ".exists?" do
    it "checks if the CSV file exists" do
      expect(Cbase::CsvFile.exists?).to be_true
    end
  end

  describe ".delete_file" do
    it "check if can delete CSV file" do
      Cbase::CsvFile.delete_file
      expect(Cbase::CsvFile.exists?).to be_false
    end
  end
end 