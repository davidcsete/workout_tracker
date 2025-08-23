class AnalyticsController < ApplicationController
  before_action :ensure_admin

  def index
    @today_dau = UserActivity.daily_active_users(Date.current)
    @yesterday_dau = UserActivity.daily_active_users(Date.yesterday)
    @this_week_wau = UserActivity.weekly_active_users(Date.current)
    @this_month_mau = UserActivity.monthly_active_users(Date.current)

    # Last 30 days DAU trend
    @dau_trend = (29.days.ago.to_date..Date.current).map do |date|
      {
        date: date,
        dau: UserActivity.daily_active_users(date)
      }
    end

    # Top active users this week
    @top_users = UserActivity
      .joins(:user)
      .for_date_range(Date.current.beginning_of_week, Date.current.end_of_week)
      .group(:user_id)
      .sum(:page_views)
      .sort_by { |_, views| -views }
      .first(10)
      .map { |user_id, views| [ User.find(user_id), views ] }
  end

  private

  def ensure_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
