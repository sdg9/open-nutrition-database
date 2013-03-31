ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

FakeWeb.allow_net_connect = false
Nutrition::FatSecret.sleep_amount = 0

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  teardown do
    FakeWeb.clean_registry
  end

  def self.setup_upc_mocking
    setup do
      Upc::Resolver.expects(:resolve).returns(nil).at_least(0)
    end

    teardown do
      Upc::Resolver.unstub(:resolve)
    end
  end

  def mock_upc(upc, description)
    return_value = {
      :upc         => upc,
      :description => description
    }
    Upc::Resolver.expects(:resolve).with(upc).returns(return_value).at_least(0)
  end
end

UPC_DATABASE_SECRET = "TESTMAN"
UPC_DOT_COM_KEY     = "TESTMAN"
FATSECRET_KEY       = 'TESTMAN'
FATSECRET_SECRET    = 'TESTMAN'

  FatSecret.init(FATSECRET_KEY,FATSECRET_SECRET)


require 'mocha/setup'
