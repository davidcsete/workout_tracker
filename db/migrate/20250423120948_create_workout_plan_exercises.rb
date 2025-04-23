class CreateWorkoutPlanExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_plan_exercises do |t|
      t.references :workout_plan, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
