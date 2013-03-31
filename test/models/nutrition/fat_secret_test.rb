require 'test_helper'

class Nutrition::FatSecretTest < ActiveSupport::TestCase
  setup_upc_mocking

  test "success" do
    mock_upc('077975088227', 'Snyder\'s Of Hanover Pretzel Pieces Hard Sourdough Honey Mustard & Onion')

    ::FatSecret.expects(:search_food).with("Snyders%20Of%20Hanover%20Pretzel%20Pieces%20Hard%20Sourdough%20Honey%20Mustard%20%20Onion").returns(ActiveSupport::JSON.decode(File.open('test/fixtures/fat_secret_search_success').read))

    ::FatSecret.expects(:food).returns(ActiveSupport::JSON.decode(File.open('test/fixtures/fat_secret_lookup_success').read))
    nutrition = Nutrition::FatSecret.resolve(:upc => '077975088227')

    assert_equal 'Snyder\'s Of Hanover Pretzel Pieces Hard Sourdough Honey Mustard & Onion', nutrition[:description]
    assert_equal 'Snyder\'s of Hanover', nutrition[:brand_name]
    assert_equal 'Honey Mustard & Onion Pretzel Pieces', nutrition[:product_name]

    details = nutrition[:nutrition]
    assert_not_nil details
    assert_equal "140", details[:calories]
  end

  test "upc resolution fails" do
    nutrition = Nutrition::FatSecret.resolve(:upc => '077975088227')
    assert_nil nutrition
  end

  test "search doesn't come back with any results" do
    mock_upc('077975088227', 'Snyder\'s Of Hanover Pretzel Pieces Hard Sourdough Honey Mustard & Onion')

    ::FatSecret.expects(:search_food).with("Snyders%20Of%20Hanover%20Pretzel%20Pieces%20Hard%20Sourdough%20Honey%20Mustard%20%20Onion").returns(ActiveSupport::JSON.decode(File.open('test/fixtures/fat_secret_search_no_results').read))
    
    nutrition = Nutrition::FatSecret.resolve(:upc => '077975088227')

    expected = { :description =>  'Snyder\'s Of Hanover Pretzel Pieces Hard Sourdough Honey Mustard & Onion' }
    assert_equal expected, nutrition
  end

  test "food lookup fails" do
    mock_upc('077975088227', 'Snyder\'s Of Hanover Pretzel Pieces Hard Sourdough Honey Mustard & Onion')

    ::FatSecret.expects(:search_food).with("Snyders%20Of%20Hanover%20Pretzel%20Pieces%20Hard%20Sourdough%20Honey%20Mustard%20%20Onion").returns(ActiveSupport::JSON.decode(File.open('test/fixtures/fat_secret_search_success').read))

    ::FatSecret.expects(:food).returns(nil)
    nutrition = Nutrition::FatSecret.resolve(:upc => '077975088227')

    expected = { :description =>  'Snyder\'s Of Hanover Pretzel Pieces Hard Sourdough Honey Mustard & Onion' }
    assert_equal expected, nutrition
 
  end
end
