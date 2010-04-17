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
  
  def test_build_from_data
    assert_nil Teaching.build_from_data(nil)
    assert_nil Teaching.build_from_data({})
    
    teaching = Teaching.build_from_data(@data)
    assert_equal @data[:level], teaching.level
    assert_equal @data[:area], teaching.area
    assert_equal @data[:teaching], teaching.teaching
    assert_equal @data[:mode], teaching.mode
  end
  
  def test_build_from_data_with_concerted
    teaching = Teaching.build_from_data(@data.merge(:concerted => "Si"))
    assert_equal true, teaching.concerted
    
    teaching = Teaching.build_from_data(@data.merge(:concerted => "Sí"))
    assert_equal true, teaching.concerted
    
    teaching = Teaching.build_from_data(@data.merge(:concerted => "si"))
    assert_equal true, teaching.concerted
  end
  
  def test_build_from_data_with_indifferent_access
    @data.delete(:level)
    teaching = Teaching.build_from_data(@data.merge('level' => 'CFGS'))
    assert_equal 'CFGS', teaching.level
  end
  
end
