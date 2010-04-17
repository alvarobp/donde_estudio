require File.dirname(__FILE__) + '/../test_helper'

class CentreTest < ActiveSupport::TestCase
  
  def setup
    @data = { 
      :code => "1234", :url => "centre_url", :denomination => "Centre Wadus",
      :generic_denomination => "Highschool", :country => "España", :region => "Comunidad Valenciana",
      :province => "Valencia", :town => "Burjassot", :locality => "Burjasot", :county => "L'Horta",
      :address => "Calle Colón 16", :postal_code => "46100", :ownership => "Centro público",
      :centre_type => "Centro Público de Enseñanza a Distancia"
    }
  end
  
  def test_create_from_data
    assert_nil Centre.build_from_data(nil)
    assert_nil Centre.build_from_data({})
    
    centre = Centre.build_from_data(@data)
    assert_equal @data[:code], centre.code
    assert_equal @data[:url], centre.url
    assert_equal @data[:denomination], centre.denomination
    assert_equal @data[:generic_denomination], centre.generic_denomination
    assert_equal @data[:country], centre.country
    assert_equal @data[:region], centre.region
    assert_equal @data[:province], centre.province
    assert_equal @data[:town], centre.town
    assert_equal @data[:locality], centre.locality
    assert_equal @data[:county], centre.county
    assert_equal @data[:address], centre.address
    assert_equal @data[:postal_code], centre.postal_code
    assert_equal @data[:ownership], centre.ownership
    assert_equal @data[:centre_type], centre.centre_type
  end
  
  def test_build_from_data_with_concerted
    centre = Centre.build_from_data(@data.merge(:ownership => "Centro privado", :concerted => "Si"))
    assert_equal true, centre.concerted
    assert_equal "Centro concertado", centre.ownership
    
    centre = Centre.build_from_data(@data.merge(:ownership => "Centro privado", :concerted => "Sí"))
    assert_equal true, centre.concerted
    assert_equal "Centro concertado", centre.ownership
    
    centre = Centre.build_from_data(@data.merge(:ownership => "Centro público", :concerted => "si"))
    assert_equal true, centre.concerted
    assert_equal "Centro concertado", centre.ownership
    
    centre = Centre.build_from_data(@data.merge(:ownership => "Centro público", :concerted => "No"))
    assert_equal false, centre.concerted
    assert_equal "Centro público", centre.ownership
    
    centre = Centre.build_from_data(@data.merge(:ownership => "Centro público", :concerted => ""))
    assert_equal false, centre.concerted
    assert_equal "Centro público", centre.ownership
  end
  
  def test_build_from_data_with_indifferent_access
    @data.delete(:code)
    centre = Centre.build_from_data(@data.merge('code' => '09876'))
    assert_equal "09876", centre.code
  end
  
  def test_build_from_data_with_teachings
    teachings = {
      :teachings => [
        {:level => "level1", :area => "area1", :teaching => "teaching1", :mode => "mode1", :concerted => "Sí"},
        {:level => "level2", :area => "area2", :teaching => "teaching2", :mode => "mode2", :concerted => "No"}
      ]
    }
    
    centre = Centre.build_from_data(@data.merge(teachings))
    
    assert_equal 2, centre.teachings.size
    
    assert_equal "level1", centre.teachings[0].level
    assert_equal "teaching1", centre.teachings[0].teaching
    
    assert_equal "level2", centre.teachings[1].level
    assert_equal "teaching2", centre.teachings[1].teaching
  end
  
end
