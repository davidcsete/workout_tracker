class WorkoutPlanExercise < ApplicationRecord
  belongs_to :workout_plan
  belongs_to :exercise

  validates :day_of_the_week, presence: true
  validates :order, presence: true

  enum :day_of_the_week, {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
  }

  default_scope { order(:day_of_the_week, :order) }
end
