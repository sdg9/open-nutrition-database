require 'net/http'

module Upc
  module Resolver
    class DatabaseDotCom

      def self.resolve(upc)
        net = Net::HTTP.new("www.upcdatabase.com", 80)

        server = XML::XMLRPC::Client.new(net, "/xmlrpc")
        result = server.call('lookup', 'rpc_key' => UPC_DOT_COM_KEY, 'upc' => upc)

        return nil if result.nil? || result.params.nil? || result.params.first.nil?

        description = result.params.first[:description]
        return nil if description.nil?

        {
          :upc         => upc,
          :description => description
        }
      end
    end
  end
end
