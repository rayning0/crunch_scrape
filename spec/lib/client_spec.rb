require 'spec_helper'

describe Cbase::Client do
  describe "#csv" do
    it "fetches a page and passes it to the parser" do
      parser = mock('parser')

      datetime_mock = mock('datetime')
      DateTime.expects(:now).returns(datetime_mock)

      datetime_mock.expects(:to_date).returns(Date.parse('20100102'))

      todays_path = "/daily/content_20100102_web.html"

      Net::HTTP.expects(:get).
        with('static.crunchbase.com', '/daily/content_20100102_web.html').
        returns("the page content")

      Cbase::IndexParser.expects(:new).with("the page content").returns(parser)

      parser.expects(:company_urls)
      Cbase::Client.new.csv
    end
  end
end
