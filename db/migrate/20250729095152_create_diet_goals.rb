class CreateDietGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :diet_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :daily_calories
      t.float :protein_percentage
      t.float :carb_percentage
      t.float :fat_percentage
      t.float :weight_change_per_week
      t.boolean :is_custom

      t.timestamps
    end
  end
end
