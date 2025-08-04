class ExerciseTracking < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  validates :reps, presence: { message: "can't be blank" },
                   numericality: { greater_than: 0, only_integer: true, message: "must be at least 1" }
  validates :weight, presence: { message: "can't be blank" },
                     numericality: { greater_than: 0, message: "must be greater than 0" }

  scope :today_for_user, ->(user) { where(user: user, performed_at: Time.zone.today.all_day).order(performed_at: :desc) }
  scope :for_date_and_user, ->(date, user) { where(user: user, performed_at: date.all_day).order(performed_at: :desc) }
end
