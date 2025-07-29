class AddGoalTypeToGoals < ActiveRecord::Migration[8.0]
  def change
    add_column :goals, :goal_type, :integer, default: 0, null: false
    add_index :goals, :goal_type
  end
end
