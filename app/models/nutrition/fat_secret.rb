module Nutrition
  class FatSecret
    cattr_accessor :sleep_amount
    self.sleep_amount = 1

    # options must either :upc or :query key
    def self.resolve(options={})
      raise ArgumentError, "FatSecret requires upc or query" if options[:upc].blank? && options[:query].blank?

      query = options[:query]
      if query.blank?
        Rails.logger.info("FatSecret resolving UPC `#{options[:upc]}`")
        upc_details = Upc::Resolver.resolve(options[:upc]) 
        query = upc_details[:description] if upc_details
        return nil if query.blank?
      end
      Rails.logger.info("FatSecret: Resolving Nutrition for `#{query}`")
      description = query.dup

      # The API doesn't deal with ampersands or quotes well
      results = ::FatSecret.search_food(query.gsub(/&|'|"/, "").gsub(" ", "%20"))

      Rails.logger.info("FatSecret: Food Search Result-  #{results.to_json}")
      if results.blank? || results['foods'].blank? || 
        results['foods']['food'].blank?
        return { :description => description }
      end

      food = results['foods']['food']
      food = food.first if food.is_a?(Array)

      food_id = food['food_id']

      # API doesn't like it when we query it twice in a row
      unless Nutrition::FatSecret.sleep_amount.zero?
        sleep(Nutrition::FatSecret.sleep_amount)
      end

      fsf = ::FatSecret.food(food_id)
      Rails.logger.info("FatSecret: found food: #{fsf.to_json}")

      if fsf.blank? || fsf['food'].blank? || fsf['food']['servings'].blank?
        return { :description => description }
      end

      product = fsf['food']
      serving = product['servings']
      serving = serving.first if serving.is_a?(Array)
      serving = serving['serving'] if serving.has_key?('serving')
      serving = serving.first if serving.is_a?(Array)

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
