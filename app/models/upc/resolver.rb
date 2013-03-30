module Upc
  module Resolver
    mattr_accessor :resolvers

    # Setup some defaults
    self.resolvers = [ Upc::Resolver::DatabaseDotOrg, Upc::Resolver::DatabaseDotCom ]


    def self.resolve(upc)
      self.resolvers.each do |resolver|
        resp = resolver.send(:resolve, upc)
        return resp if resp
      end

      nil
    end
  end
end
