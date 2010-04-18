require File.dirname(__FILE__) + '/../../test_helper'

class OpenEducacion::CentresTest < ActiveSupport::TestCase
  context "A centres call" do
    
    setup do
      @centres = OpenEducacion::Centres.all
    end
    
    should "give me 30562 centres in total" do
      assert_equal(30562, @centres.size)
    end
    
    should "give me as first" do
      assert_equal("04501032", @centres.first)
    end
    
    should "give me as last" do
      assert_equal("52000211", @centres.last)
    end
  end
end