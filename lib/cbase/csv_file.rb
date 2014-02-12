class Cbase::CsvFile
  attr_reader :nycompanies

  HEADER = ["Company", "Website", "Phone", "Address", "Email", "Team Page", "Person 1", "Job 1", "Person 2", "Job 2", "Person 3", "Job 3"]
  PATH = File.expand_path('../.') + "/crunch_scrape/data/nycompanies.csv"

  def initialize(nycompanies = nil)
    @nycompanies = nycompanies
  end

  def make_csv_header
    CSV.open(PATH, "wb") do |csv|
      csv << HEADER
    end
  end

  def to_csv
    make_csv_header
    nycompanies.each do |c|
      CSV.open(PATH, "ab") do |csv|
        csv << [c.name, c.url, c.phone, 
                c.nyaddress, c.email, c.mgmt_team, 
                c.person[0], c.job[0], 
                c.person[1], c.job[1], 
                c.person[2], c.job[2]]
      end
    end
  end
end