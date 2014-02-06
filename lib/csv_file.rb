class CsvFile

  def make_csv_header
    CSV.open(PATH, "wb") do |csv|
      csv << HEADER
    end
  end

  def to_csv
  end

  HEADER = ["Company", "Website", "Phone", "Address", "Email", "Team Page", "Person 1", "Job 1", "Person 2", "Job 2", "Person 3", "Job 3"]
  PATH = "#{Dir.pwd}/lib/nycompanies.csv"
end