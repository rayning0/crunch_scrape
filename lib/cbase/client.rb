require 'date'
require 'net/http'

class Cbase::Client
  def csv
    date_url = DateTime.now.to_date.
                strftime("/daily/content_%Y%m%d_web.html")

    page_content = Net::HTTP.get('static.crunchbase.com', date_url)
    index = Cbase::IndexParser.new(page_content)
    index.company_urls
  end
end
