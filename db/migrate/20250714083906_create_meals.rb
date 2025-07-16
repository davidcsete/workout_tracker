class CreateMeals < ActiveRecord::Migration[8.0]
  def change
    create_table :meals do |t|
      t.string :name
      t.integer :meal_type
      t.datetime :consumed_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
