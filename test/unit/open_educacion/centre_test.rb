require File.dirname(__FILE__) + '/../../test_helper'

class OpenEducacion::CentreTest < ActiveSupport::TestCase
  context "A centre" do
    setup do
      @centre = OpenEducacion::Centre.new("48010027")
      #@centre.stubs(:document).returns(Nokogiri::HTML(File.open("test/fixtures/course.html")))
    end
    
    should "have denomination" do
      assert_equal "CAÑADA DE LA ENCINA", @centre.denomination      
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

    should "have postal ownership" do
      assert_equal "Centro público", @centre.ownership
    end
    
    should "have postal centre_type" do
      assert_equal "Instituto de Educación Secundaria (IES)", @centre.centre_type
    end
    
    should "have postal generic_denomination" do
      assert_equal "Instituto de Educación Secundaria", @centre.generic_denomination
    end
    
    should "have postal concerted" do
      assert_equal "", @centre.concerted
    end
    
    should "have 7 teachings" do
      assert_equal 7, @centre.teachings.size
    end

    should "have Educación Secundaria Obligatoria" do
      assert_equal "Educación Secundaria Obligatoria", @centre.teachings.first.teaching
    end

    should "have  the 'presencial' mode on the first" do
      assert_equal "Presencial", @centre.teachings.first.mode
    end
    
    should "have  the 'presencial' mode on the last" do
      assert_equal "Presencial", @centre.teachings.last.mode
    end
    
    should "have Educación Secundaria Enseñanzas de cualificación profesional inicial de la familia administración y gestión" do
      assert_equal "Enseñanzas de cualificación profesional inicial de la familia administración y gestión", @centre.teachings.last.teaching
    end

    should "have area" do
      assert_equal "ADMINISTRACIÓN Y GESTIÓN", @centre.teachings.last.area
    end

    should "have level" do
      assert_equal "Ciclos Formativos de Formación Profesional de Grado Medio (LOE)", @centre.teachings[4].level
    end    
  end    
end
