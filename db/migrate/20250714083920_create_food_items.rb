class CreateFoodItems < ActiveRecord::Migration[8.0]
  def change
    create_table :food_items do |t|
      t.string :name
      t.integer :calories
      t.float :protein
      t.float :carbs
      t.float :fats
      t.references :meal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
