class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|

      t.timestamps
    end
  end
end
