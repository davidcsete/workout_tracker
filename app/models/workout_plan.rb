class WorkoutPlan < ApplicationRecord
  belongs_to :user
  has_many :workout_plan_exercises
  has_many :exercises, through: :workout_plan_exercises
end
