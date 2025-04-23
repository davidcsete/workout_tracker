class Weekday < ApplicationRecord
    has_many :exercise_weekdays
    has_many :exercises, through: :exercise_weekdays
end
