require File.dirname(__FILE__) + '/../../test_helper'

module OpenEducacion
  class CentreTest < ActiveSupport::TestCase
    context "A centre" do
      setup do
        @centre = Centre.new(2000)
        @centre.stubs(:document).returns(Nokogiri::HTML(File.open("test/fixtures/course.html")))
      end

      should "have region" do
        assert_equal "COMUNIDAD AUTÓNOMA DE CASTILLA-LA MANCHA", @centre.region
      end

      should "have province" do
        assert_equal "CUENCA", @centre.province
      end

      should "have province_subdivision" do
        assert_equal "", @centre.province_subdivision
      end

      should "have country" do
        assert_equal "ESPAÑA", @centre.country
      end
      
      should "have county" do
        assert_equal "", @centre.county
      end

      should "have town" do
        assert_equal "INIESTA", @centre.town
      end

      should "have locality" do
        assert_equal "INIESTA", @centre.locality
      end

      should "have address" do
        assert_equal "CL. ERA PAREJA, 11", @centre.address
      end

      should "have url" do
        assert_equal "http://www.educa.jccm.es/educa-jccm/cm/educa_jccm/ProxiaSQLEngine.1.1.tkContent.12567/tkShowDetailView?idQuery=961&CENT_ID=16000899&CLOC=161130003&CPROV=16", @centre.url
      end

      should "have postal code" do
        assert_equal "16235", @centre.postal_code
      end

    end
    
  end
end
