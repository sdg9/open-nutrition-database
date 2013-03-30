module Upc
  module Resolver
    class DatabaseDotOrg

      def self.resolve(upc)
        resp = HTTParty.get("http://upcdatabase.org/api/json/#{UPC_DATABASE_SECRET}/#{upc}")
        return nil unless resp.success?
        return nil unless [true, "true"].include?(resp['valid'])

        description = resp['description']
        return nil unless description.present?

        {
          :upc         => upc,
          :description => description
        }
      end
    end
  end
end
