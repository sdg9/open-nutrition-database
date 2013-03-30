require 'net/http'

class Food < ActiveRecord::Base


  # 044000046880
  def self.nutrition_for_upc(upc)
    lookup_nutrition(lookup_upc(upc)['description'])
  end

  def self.lookup_upc(upc)
    HTTParty.get("http://upcdatabase.org/api/json/#{UPC_DATABASE_SECRET}/#{upc}")
  end

  def self.lookup_upc2(upc)
    net = Net::HTTP.new("www.upcdatabase.com", 80)

    server = XML::XMLRPC::Client.new(net, "/xmlrpc")
    result = server.call('lookup', 'rpc_key' => UPC_DOT_COM_KEY, 'upc' => upc)
    result.params.first
  end

  def self.lookup_nutrition(query)
    puts "QUERY: #{query}"
    results = FatSecret.search_food(query.gsub(" ", "%20"))
    food = results['foods']['food']
    food = food.first if food.is_a?(Array)

    food_id = food['food_id']
    puts food_id

    fsf = FatSecret.food(food_id)
    puts "FSF: #{fsf.inspect}"
    fsf['food']
  end
end
