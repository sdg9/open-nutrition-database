require 'test_helper'

class Upc::Resolver::DatabaseDotOrgTest < ActiveSupport::TestCase
  test "success" do
    FakeWeb.register_uri(:get, 'http://upcdatabase.org/api/json/TESTMAN/044000046880', :body => File.open('test/fixtures/database_dot_org_success').read, :content_type => 'application/json')

    details = Upc::Resolver::DatabaseDotOrg.resolve("044000046880")

    expected = {
      :upc         => '044000046880',
      :description => 'Nabisco Wheat Thins Crackers Original'
    }

    assert_equal expected, details
  end

  test "failure to resolve" do
    FakeWeb.register_uri(:get, 'http://upcdatabase.org/api/json/TESTMAN/044000046880', :body => File.open('test/fixtures/database_dot_org_failure').read, :content_type => 'application/json')

    details = Upc::Resolver::DatabaseDotOrg.resolve("044000046880")

    assert_nil details
  end
end
