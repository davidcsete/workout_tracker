class CreateExerciseWeekdays < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_weekdays do |t|
      t.references :exercise, null: false, foreign_key: true
      t.references :weekday, null: false, foreign_key: true

      t.timestamps
    end
  end
end
