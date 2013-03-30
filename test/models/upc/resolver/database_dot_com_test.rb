require 'test_helper'

class Upc::Resolver::DatabaseDotComTest < ActiveSupport::TestCase
  test "success" do
    FakeWeb.register_uri(:post, 'http://www.upcdatabase.com/xmlrpc', :body => File.open('test/fixtures/database_dot_com_success').read)

    details = Upc::Resolver::DatabaseDotCom.resolve("044000046880")

    expected = {
      :upc         => '044000046880',
      :description => 'Nabisco Wheat Thins Crackers Original'
    }

    assert_equal expected, details
  end

  test "failure to resolve" do
    FakeWeb.register_uri(:post, 'http://www.upcdatabase.com/xmlrpc', :body => File.open('test/fixtures/database_dot_com_failure').read)

    details = Upc::Resolver::DatabaseDotCom.resolve("044000046880")

    assert_nil details
  end
end
