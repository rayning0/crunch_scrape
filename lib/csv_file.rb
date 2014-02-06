class CsvFile

  def make_csv_header
    CSV.open(PATH, "wb") do |csv|
      csv << HEADER
    end
  end

  def to_csv(nycompanies)
    make_csv_header
    nycompanies.each do |c|
      begin 
        CSV.open(PATH, "ab") do |csv|
          csv << [c[:name], c[:url], c[:phone], 
                  c[:address], c[:email], c[:mgmt_team], 
                  c[:person1], c[:job1], 
                  c[:person2], c[:job2], 
                  c[:person3], c[:job3]]
        end
      rescue StandardError => e 
          $stderr.puts "#{permalink} and office = #{office}"
          $stderr.puts e.message
          $stderr.puts e.backtrace.inspect
      end
    end
  end

  HEADER = ["Company", "Website", "Phone", "Address", "Email", "Team Page", "Person 1", "Job 1", "Person 2", "Job 2", "Person 3", "Job 3"]
  PATH = "#{Dir.pwd}/nycompanies.csv"

end