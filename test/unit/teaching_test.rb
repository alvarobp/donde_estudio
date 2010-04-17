require File.dirname(__FILE__) + '/../test_helper'

class TeachingTest < ActiveSupport::TestCase
  
  def setup
    @data = { 
      :level => "Ciclo Formativo de Grado Superior",
      :area => "Jardinería",
      :teaching => "Valencia",
      :mode => "Presencial"
    }
  end
  
  def test_attributes_from_data
    assert_equal({}, Teaching.attributes_from_data(nil))
    assert_equal({}, Teaching.attributes_from_data({}))
    
    atts = Teaching.attributes_from_data(@data)
    assert_equal @data[:level], atts[:level]
    assert_equal @data[:area], atts[:area]
    assert_equal @data[:teaching], atts[:teaching]
    assert_equal @data[:mode], atts[:mode]
  end
  
  def test_attributes_from_data_with_concerted
    atts = Teaching.attributes_from_data(@data.merge(:concerted => "Si"))
    assert_equal true, atts[:concerted]
    
    atts = Teaching.attributes_from_data(@data.merge(:concerted => "Sí"))
    assert_equal true, atts[:concerted]
    
    atts = Teaching.attributes_from_data(@data.merge(:concerted => "si"))
    assert_equal true, atts[:concerted]
    
    atts = Teaching.attributes_from_data(@data.merge(:concerted => "No"))
    assert_equal false, atts[:concerted]
    
    atts = Teaching.attributes_from_data(@data.merge(:concerted => ""))
    assert_equal false, atts[:concerted]
  end
  
  def test_attributes_from_data_with_indifferent_access
    @data.delete(:level)
    atts = Teaching.attributes_from_data(@data.merge('level' => 'CFGS'))
    assert_equal 'CFGS', atts[:level]
  end
  
end
