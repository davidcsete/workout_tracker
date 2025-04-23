class CreateExerciseTrackings < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_trackings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :reps
      t.float :weight
      t.datetime :performed_at

      t.timestamps
    end
  end
end
