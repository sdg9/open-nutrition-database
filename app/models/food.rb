class Food < ActiveRecord::Base
  serialize :nutrition, JSON
  

  def self.from_upc(upc)
    food = Food.where(:upc => upc).first
    return food if food

    nutrition_data = Nutrition::FatSecret.resolve(:upc => upc)
    Rails.logger.info("Found: #{nutrition_data.inspect}")
    return nil if nutrition_data.blank?

    Food.create(nutrition_data.merge({:upc => upc}))
  end
end
