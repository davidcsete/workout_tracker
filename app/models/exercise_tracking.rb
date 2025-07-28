class ExerciseTracking < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  scope :today_for_user, ->(user) { where(user: user, performed_at: Time.zone.today.all_day).order(performed_at: :desc) }
  scope :for_date_and_user, ->(date, user) { where(user: user, performed_at: date.all_day).order(performed_at: :desc) }
end
