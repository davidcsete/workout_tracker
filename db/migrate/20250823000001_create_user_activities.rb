class CreateUserActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :user_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.date :activity_date, null: false
      t.integer :page_views, default: 0
      t.integer :actions_count, default: 0
      t.timestamps
    end

    add_index :user_activities, [ :user_id, :activity_date ], unique: true
    add_index :user_activities, :activity_date
  end
end
