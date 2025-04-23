class ExerciseTracking < ApplicationRecord
  belongs_to :user
  belongs_to :exercise
  scope :today_for_user, ->(user) { where(user: user, created_at: Time.zone.today.all_day).order(created_at: :desc) }
end
