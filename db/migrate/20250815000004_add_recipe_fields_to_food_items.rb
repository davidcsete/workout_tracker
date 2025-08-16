class AddRecipeFieldsToFoodItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :food_items, :recipe, null: true, foreign_key: true
    add_column :food_items, :recipe_servings, :decimal, precision: 8, scale: 2
  end
end
