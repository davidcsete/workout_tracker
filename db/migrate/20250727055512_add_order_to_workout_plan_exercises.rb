class AddOrderToWorkoutPlanExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_plan_exercises, :order, :integer
  end
end
