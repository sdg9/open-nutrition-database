class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :description
      t.string :brand_name
      t.string :product_name
      t.text   :nutrition
      t.string :upc
      t.timestamps
    end

    add_index :foods, :upc
  end
end
