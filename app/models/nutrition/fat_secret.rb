module Nutrition
  class FatSecret

    # options must either :upc or :query key
    def self.resolve(options={})
      raise ArgumentError, "Nutrition::FatSecret requires upc or query" if options[:upc].blank? && options[:query].blank?

      query = options[:query]
      if query.blank?
        upc_details = Upc::Resolver.resolve(options[:upc]) 
        query = upc_details[:description] if upc_details
      end
      description = query.dup

      # The API doesn't deal with ampersands or quotes well
      query.gsub!(/&|'|"/, "").gsub!(" ", "%20")

      results = ::FatSecret.search_food(query)
      food = results['foods']['food']
      food = food.first if food.is_a?(Array)

      food_id = food['food_id']

      fsf = ::FatSecret.food(food_id)
      product = fsf['food']
      serving = product['servings']
      serving = serving.first if serving.is_a?(Array)
      serving = serving['serving'] if serving.has_key?('serving')

      nutrition = serving.deep_symbolize_keys.except(:serving_url, :serving_id)

      {
        :description  => description,
        :brand_name   => product['brand_name'],
        :product_name => product['food_name'],
        :nutrition    => nutrition
      }
    end

  end
end
