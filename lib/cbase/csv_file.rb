class Cbase::CsvFile
  attr_reader :csv_row

  PATH = File.expand_path('../.') + "/crunch_scrape/data/companies.csv"
  
  def initialize(csv_row = nil)
    @csv_row = csv_row
  end

  def make_csv_header(header)
    CSV.open(PATH, "wb") do |csv|
      csv << header
      csv << []
    end
  end

  def to_csv
    CSV.open(PATH, "ab") do |csv|
      csv << csv_row
    end
  end

  def self.exists?
    File.exist?(PATH)
  end
end