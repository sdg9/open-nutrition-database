require 'test_helper'

class FoodsControllerTest < ActionController::TestCase
  setup_fat_secret_mocking

  test "success" do
    food = FactoryGirl.create(:food)
    get :show, :id => food.upc
    assert_response :success
    assert_equal food.upc, json_resp['upc']
    assert json_resp['id'].present?
  end

  test "not found" do
    get :show, :id => "yolo"
    assert_response :not_found
  end


  private

  def json_resp
    ActiveSupport::JSON.decode(@response.body)
  end
end
