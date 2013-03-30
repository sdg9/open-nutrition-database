ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

FakeWeb.allow_net_connect = false

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  teardown do
    FakeWeb.clean_registry
  end
end

UPC_DATABASE_SECRET = "TESTMAN"
UPC_DOT_COM_KEY     = "TESTMAN"
