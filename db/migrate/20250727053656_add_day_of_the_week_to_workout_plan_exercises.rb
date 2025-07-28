class AddDayOfTheWeekToWorkoutPlanExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_plan_exercises, :day_of_the_week, :integer
  end
end
