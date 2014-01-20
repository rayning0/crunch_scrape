require 'spec_helper'

describe Cbase::IndexParser do
  describe "initialization" do
    it "accepts an html page" do
      Cbase::IndexParser.new("the page").page.must_equal "the page"
    end
  end

  describe "#detail_urls" do
    detail_page = <<-EOS
      <html>
        <a href="http://www.crunchbase.com/company/rapidminer">foo</a>
      </html>
    EOS

    it "returns an array of detail page urls" do

    end
  end
end
