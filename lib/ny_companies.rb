class NYCompanies
  def get_ny_companies(permalinks)
    permalinks.map {|permalink|
      company = company_hash(permalink) 
      company if in_ny?(company)
    }.compact
  end
# #4. If company office is in New York, record its data

#           top1, top2, top3 = comp["relationships"][0..2]  # top 3 people 
#           if top1.nil?
#             top1_fname, top1_lname, top1_title = nil, nil, nil 
#           else
#             top1_fname = top1["person"]["first_name"]
#             top1_lname = top1["person"]["last_name"]
#             top1_title = top1["title"]
#           end
#           if top2.nil?
#             top2_fname, top2_lname, top2_title = nil, nil, nil 
#           else
#             top2_fname = top2["person"]["first_name"]
#             top2_lname = top2["person"]["last_name"]
#             top2_title = top2["title"]
#           end
#           if top3.nil?
#             top3_fname, top3_lname, top3_title = nil, nil, nil 
#           else
#             top3_fname = top3["person"]["first_name"]
#             top3_lname = top3["person"]["last_name"]
#             top3_title = top3["title"]
#           end

# #5. For this NY company, add its data to CSV file
#           csv << [comp["name"], "=HYPERLINK(\"#{comp["homepage_url"]}\")", comp["phone_number"], 

#             "=HYPERLINK(\"https://www.google.com/maps/preview/place/'" + "#{office["address1"]} #{office["address2"]}" + " New York'\")", comp["email_address"], 

#             "=HYPERLINK(\"https://www.google.com/search?q='management+team'+#{permalink}\")", 

#             "#{top1_fname} #{top1_lname}", "#{top1_title}", 
#             "#{top2_fname} #{top2_lname}", "#{top2_title}",
#             "#{top3_fname} #{top3_lname}", "#{top3_title}"]
#         rescue StandardError => e
#           $stderr.puts "#{permalink} and office = #{office}"
#           $stderr.puts e.message
#           $stderr.puts e.backtrace.inspect
#         end
#       end
#     end
    
#
  

  def to_csv
  end

  def company_hash(permalink)
    company_url = "http://api.crunchbase.com/v/1/company/#{permalink}.js?api_key=#{CompanyList::API_KEY}"
    begin
      response = Net::HTTP.get_response(URI(company_url))
      comp_hash = JSON.parse(response.body)
    rescue StandardError => e
      $stderr.puts permalink
      $stderr.puts e.message
      $stderr.puts e.backtrace.inspect
    end
    comp_hash
  end 

  private

  def in_ny?(company)
    company["offices"].each do |office|
      return true if office["city"] == "New York"
    end
    false
  end
end