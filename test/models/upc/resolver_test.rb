require 'test_helper'

class Upc::ResolverTest < ActiveSupport::TestCase
  setup do
    Upc::Resolver.resolvers = [Upc::Resolver::DatabaseDotOrg, Upc::Resolver::DatabaseDotCom]
  end

  test "first success" do
    expected = {
      :upc         => '044000046880',
      :description => 'Nabisco Wheat Thins Crackers Original'
    }

    Upc::Resolver::DatabaseDotOrg.expects(:resolve).once.returns(expected)
    Upc::Resolver::DatabaseDotCom.expects(:resolve).never

    details = Upc::Resolver.resolve("044000046880")
    assert_equal expected, details
  end

  test "second success" do
    expected = {
      :upc         => '044000046880',
      :description => 'Nabisco Wheat Thins Crackers Original'
    }

    Upc::Resolver::DatabaseDotOrg.expects(:resolve).once.returns(nil)
    Upc::Resolver::DatabaseDotCom.expects(:resolve).once.returns(expected)

    details = Upc::Resolver.resolve("044000046880")
    assert_equal expected, details
  end

  test "none succeed" do
    Upc::Resolver::DatabaseDotOrg.expects(:resolve).once.returns(nil)
    Upc::Resolver::DatabaseDotCom.expects(:resolve).once.returns(nil)

    details = Upc::Resolver.resolve("044000046880")
    assert_nil details
  end
end
