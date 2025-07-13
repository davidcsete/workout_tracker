class CreateUserDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :user_details do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :age
      t.float :height
      t.float :bodyweight
      t.references :goal, null: false, foreign_key: true
      t.references :lifestyle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
