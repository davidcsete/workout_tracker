class Weekday < ApplicationRecord
    has_many :exercise_weekdays, dependent: :destroy
    has_many :exercises, through: :exercise_weekdays
end
