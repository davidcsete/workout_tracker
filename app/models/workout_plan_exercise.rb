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

  # Custom ordering: Monday first (1), Sunday last (0)
  default_scope {
    order(
      Arel.sql("CASE day_of_the_week WHEN 1 THEN 1 WHEN 2 THEN 2 WHEN 3 THEN 3 WHEN 4 THEN 4 WHEN 5 THEN 5 WHEN 6 THEN 6 WHEN 0 THEN 7 END"),
      :order
    )
  }
end
