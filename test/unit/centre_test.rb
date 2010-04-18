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
  
  def test_grouped_teachings_by_level
    teachings = {
      :teachings => [
        {:level => "level1", :teaching => "teaching1"},
        {:level => "level2", :teaching => "teaching2"},
        {:level => "level1", :teaching => "teaching3"},
        {:level => "level1", :teaching => "teaching4"},
        {:level => "level2", :teaching => "teaching5"},
        {:level => nil, :teaching => "teaching6"},
        {:level => "", :teaching => "teaching7"}
      ]
    }
    
    centre = Centre.build_from_data(@data.merge(teachings))
    
    grouped_teachings = centre.grouped_teachings_by_level
    
    assert_equal 2, grouped_teachings.keys.size
    assert_equal ['level1', 'level2'], grouped_teachings.keys.sort
    
    # level1
    assert_equal 3, grouped_teachings['level1'].size
    assert grouped_teachings['level1'].map(&:teaching).include?("teaching1")
    assert grouped_teachings['level1'].map(&:teaching).include?("teaching4")
    assert grouped_teachings['level1'].map(&:teaching).include?("teaching3")
    
    # level2
    assert_equal 2, grouped_teachings['level2'].size
    assert grouped_teachings['level2'].map(&:teaching).include?("teaching2")
    assert grouped_teachings['level2'].map(&:teaching).include?("teaching5")
    
    centre = Centre.new
    assert_equal({}, centre.grouped_teachings_by_level)
    
  end
  
  def test_teachings_without_level
    teachings = {
      :teachings => [
        {:level => "level1", :teaching => "teaching1"},
        {:level => "level2", :teaching => "teaching2"},
        {:level => "level1", :teaching => "teaching3"},
        {:level => "level1", :teaching => "teaching4"},
        {:level => "level2", :teaching => "teaching5"},
        {:level => nil, :teaching => "teaching6"},
        {:level => "", :teaching => "teaching7"}
      ]
    }
    centre = Centre.build_from_data(@data.merge(teachings))
    
    assert_equal 2, centre.teachings_without_level.size
    assert_equal ['teaching6', 'teaching7'], centre.teachings_without_level.map(&:teaching).sort
  end
  
  def test_filters_to_sphinx_query
    expected_queries = ["@filter_tags *province__malaga*", "( @filter_tags *locality__alameda* | @filter_tags *locality__almogia* )", "@teachings_filter_tags *mode__presencial*"]
    query = Centre.filters_to_sphinx_query(:province => "malaga", :locality => ["alameda", "almogia"], :mode => "presencial")
    expected_queries.each {|eq| assert query.include?(eq)}
  end
  
  def test_search_with_filters
    Centre.expects(:search).with("some words #{Centre.filters_to_sphinx_query(:province => "malaga", :locality => "alameda")}", 
      has_entries(:match_mode => :extended, :per_page => 100, :page => 2) )
    
    Centre.search_with_filters(:text => "some words", 
      :filters => {:province => "malaga", :locality => "alameda"}, 
      :per_page => 100, :page => 2
    )
  end
  
end

# == Schema Information
#
# Table name: centres
#
#  id                   :integer(4)      not null, primary key
#  code                 :string(255)
#  url                  :string(255)
#  denomination         :string(255)
#  generic_denomination :string(255)
#  province_subdivision :string(255)
#  country              :string(255)
#  region               :string(255)
#  province             :string(255)
#  town                 :string(255)
#  locality             :string(255)
#  county               :string(255)
#  address              :string(255)
#  postal_code          :string(255)
#  ownership            :string(255)
#  concerted            :boolean(1)      default(FALSE)
#  centre_type          :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  filter_tags          :text
#

