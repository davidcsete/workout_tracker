class UserActivity < ApplicationRecord
  belongs_to :user

  validates :activity_date, presence: true, uniqueness: { scope: :user_id }

  scope :for_date, ->(date) { where(activity_date: date) }
  scope :for_date_range, ->(start_date, end_date) { where(activity_date: start_date..end_date) }

  def self.track_user_activity(user, action_type = :page_view)
    return unless user&.persisted?

    activity = find_or_create_by(
      user: user,
      activity_date: Date.current
    )

    case action_type
    when :page_view
      activity.increment!(:page_views)
    when :action
      activity.increment!(:actions_count)
    end

    activity
  end

  def self.daily_active_users(date = Date.current)
    for_date(date).count
  end

  def self.weekly_active_users(date = Date.current)
    start_date = date.beginning_of_week
    end_date = date.end_of_week
    for_date_range(start_date, end_date).distinct.count(:user_id)
  end

  def self.monthly_active_users(date = Date.current)
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    for_date_range(start_date, end_date).distinct.count(:user_id)
  end
end