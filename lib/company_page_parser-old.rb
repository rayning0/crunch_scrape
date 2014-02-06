require 'open-uri'
require 'json'
require 'csv'
require 'pry'
require 'pry-debugger'

company_permalinks = []

#1. Get list of all company names
result = JSON.parse(open("http://api.crunchbase.com/v/1/companies.js?api_key=an35bya6x7ktkm5z7q3q6dvg").read)

result.each do |company|
  company_permalinks << company["permalink"]
end

#2. Open spreadsheet and put header
CSV.open("/Users/user/sb/crunch_scrape/lib/nycompanies.csv", "wb") do |csv|
  csv << ["Company", "Website", "Phone", "Address", "Email", "Team Page", "Person 1", "Job 1", "Person 2", "Job 2", "Person 3", "Job 3"]
  csv << []
end

#3. For each company, get company hash
company_permalinks.each do |permalink|
  #next if %w[joost cargurus clickbank datingdirect infostud amuso edo-interactive pollstream bymk brandscan terminii evident-software mcnic-enterprises yam-labs pricearea boticca-com-limited norse-corporation emergingcast bemungo todocast-tv d-square-nv].include?(permalink)
  begin
    comp = JSON.parse(open("http://api.crunchbase.com/v/1/company/" + permalink + ".js?api_key=an35bya6x7ktkm5z7q3q6dvg").read)
  rescue StandardError => e
    $stderr.puts permalink
    $stderr.puts e.message
    $stderr.puts e.backtrace.inspect
    next
  end

#4. If company office is in New York, record its data
  comp["offices"].each do |office|
    CSV.open("/Users/user/sb/crunch_scrape/lib/cbase/nycompanies.csv", "ab") do |csv|
      if office["city"] == "New York"
        begin
          top1, top2, top3 = comp["relationships"][0..2]  # top 3 people 
          if top1.nil?
            top1_fname, top1_lname, top1_title = nil, nil, nil 
          else
            top1_fname = top1["person"]["first_name"]
            top1_lname = top1["person"]["last_name"]
            top1_title = top1["title"]
          end
          if top2.nil?
            top2_fname, top2_lname, top2_title = nil, nil, nil 
          else
            top2_fname = top2["person"]["first_name"]
            top2_lname = top2["person"]["last_name"]
            top2_title = top2["title"]
          end
          if top3.nil?
            top3_fname, top3_lname, top3_title = nil, nil, nil 
          else
            top3_fname = top3["person"]["first_name"]
            top3_lname = top3["person"]["last_name"]
            top3_title = top3["title"]
          end

#5. For this NY company, add its data to CSV file
          csv << [comp["name"], "=HYPERLINK(\"#{comp["homepage_url"]}\")", comp["phone_number"], 

            "=HYPERLINK(\"https://www.google.com/maps/preview/place/'" + "#{office["address1"]} #{office["address2"]}" + " New York'\")", comp["email_address"], 

            "=HYPERLINK(\"https://www.google.com/search?q='management+team'+#{permalink}\")", 

            "#{top1_fname} #{top1_lname}", "#{top1_title}", 
            "#{top2_fname} #{top2_lname}", "#{top2_title}",
            "#{top3_fname} #{top3_lname}", "#{top3_title}"]
        rescue StandardError => e
          $stderr.puts "#{permalink} and office = #{office}"
          $stderr.puts e.message
          $stderr.puts e.backtrace.inspect
        end
      end
    end
  end
end

###############
# 1. CompanyList class (get info from API)
# a. get_companies -- get list of all companies
# b. get_company_permalinks - get info from specific company

# 2. HandleResponse class
# b. get only NY companies

# 3. MakeCSV class
# a. method: put first line in CSV file
# b. method: put CSV for each company
