require 'test/unit'

$KCODE = "UTF8"

require 'rubygems'
require 'active_record'
require 'active_support/multibyte/chars'

# require 'ruby-debug'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
$stdout = StringIO.new

def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    create_table :centres do |t|
      t.column :filter_tags, :text
      t.column :locality, :string
      t.column :ownership, :string
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Centre < ActiveRecord::Base
  has_filter_tags :locality, :ownership
end

class FilterTagsTest < Test::Unit::TestCase
  
  def setup
    setup_db
  end
  
  def teardown
    teardown_db
  end
  
  def test_has_filter_tags_should_extend
    assert Centre.included_modules.include?(FilterTags::InstanceMethods)
  end
  
  def test_filters_class_method
    assert_equal [:locality, :ownership], Centre.filters
  end
  
  def test_filter_tag_for
    assert_nil Centre.filter_tag_for(:notfilter, "Wadus")
    
    assert_equal "locality:valencia", Centre.filter_tag_for(:locality, "Valencia")
    assert_equal "locality:madrid", Centre.filter_tag_for(:locality, "MADRID")
    assert_equal "locality:castellon_de_la_plana", Centre.filter_tag_for(:locality, "Castellón de la Plana")
    assert_equal "ownership:centro_publico", Centre.filter_tag_for(:ownership, "Centro Público")
  end
  
  def test_filter_tag_to_value
    assert_nil Centre.filter_tag_to_value("notfilter:wadus")
    
    assert_equal "valencia", Centre.filter_tag_to_value("locality:valencia")
    assert_equal "centro_publico", Centre.filter_tag_to_value("ownership:centro_publico")
    assert_equal "castellon_de_la_plana", Centre.filter_tag_to_value("locality:castellon_de_la_plana")
  end
  
  def test_filters_instance_method
    centre = Centre.new(:locality => "Valencia", :ownership => "Centro Concertado")
    
    assert_equal({:locality => "valencia", :ownership => "centro_concertado"}, centre.filters)
  end
  
  def test_serialize_filter_tags_on_save
    centre = Centre.new(:locality => "Valencia", :ownership => "Centro Concertado")
    centre.save
    
    assert_equal ["locality:valencia", "ownership:centro_concertado"], centre.filter_tags
  end
  
end