class CreateRecipeIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.decimal :quantity, precision: 8, scale: 2, null: false
      t.string :unit, default: 'grams'
      t.integer :order_index, default: 0

      t.timestamps
    end

    add_index :recipe_ingredients, [ :recipe_id, :order_index ]
  end
end
