require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test "find already in database" do
    food = FactoryGirl.create(:food)
    assert_no_difference 'Food.count' do
      fetched_food = Food.from_upc(food.upc)
      assert_equal food, fetched_food
    end
  end

  test "lookup success" do
    upc = "12345"

    nutrition_data = { :description => 'Cool Ranch Doritos' }
    Nutrition::FatSecret.expects(:resolve).with(upc).returns(nutrition_data)

    assert_difference 'Food.count' do
      fetched_food = Food.from_upc(upc)
      assert_equal nutrition_data[:description], fetched_food.description
    end

  end

  test "lookup not found" do
    upc = "12345"

    Nutrition::FatSecret.expects(:resolve).with(upc).returns(nil)

    assert_no_difference 'Food.count' do
      fetched_food = Food.from_upc(upc)
      assert_nil fetched_food
    end
  end
end
