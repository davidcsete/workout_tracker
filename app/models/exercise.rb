class Exercise < ApplicationRecord
    has_many :workout_plan_exercises
    has_many :workout_plans, through: :workout_plan_exercises
    has_many :exercise_weekdays
    has_many :weekdays, through: :exercise_weekdays
    has_many :exercise_trackings
end
