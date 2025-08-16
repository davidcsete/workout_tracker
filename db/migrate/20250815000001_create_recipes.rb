class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description
      t.text :instructions
      t.integer :servings, default: 1
      t.integer :prep_time_minutes
      t.integer :cook_time_minutes
      t.references :user, null: false, foreign_key: true
      t.boolean :public, default: false
      t.decimal :total_calories, precision: 8, scale: 2
      t.decimal :total_protein, precision: 8, scale: 2
      t.decimal :total_carbs, precision: 8, scale: 2
      t.decimal :total_fats, precision: 8, scale: 2

      t.timestamps
    end

    add_index :recipes, [ :user_id, :public ]
    add_index :recipes, :name
  end
end
