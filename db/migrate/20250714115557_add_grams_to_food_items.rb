class AddGramsToFoodItems < ActiveRecord::Migration[8.0]
  def change
    add_column :food_items, :grams, :integer
  end
end
