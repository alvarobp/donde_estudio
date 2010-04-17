require File.dirname(__FILE__) + '/../../test_helper'

module OpenEducacion
  class ScrapTest < ActiveSupport::TestCase
    context "Scraping the web" do
      setup do
        @scrap = Scrap.new
        @scrap.parse        
      end
      
      should "have 19 regions" do
        assert_equal(19, @scrap.regions.size)
      end
      
      should "have 51 regions" do
        assert_equal(51, @scrap.provinces.size)
      end 
    end
  end
end