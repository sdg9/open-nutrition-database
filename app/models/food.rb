require 'net/http'

class Food < ActiveRecord::Base
  serialize :nutrition, JSON
  

  def self.from_upc(upc)
    food = Food.where(:upc => upc).first
    return food if food

    nutrition_data = Nutrition::FatSecret.resolve(upc)
    Food.create(nutrition_data)
  end
end
