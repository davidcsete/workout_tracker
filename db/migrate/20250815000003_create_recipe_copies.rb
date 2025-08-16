class CreateRecipeCopies < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_copies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :original_recipe, null: false, foreign_key: { to_table: :recipes }
      t.references :copied_recipe, null: false, foreign_key: { to_table: :recipes }

      t.timestamps
    end

    add_index :recipe_copies, [ :user_id, :original_recipe_id ], unique: true
  end
end
