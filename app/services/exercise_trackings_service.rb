class ExerciseTrackingsService < ApplicationController
  def initialize(user_id)
    @user_id = user_id
  end

  def call
    start_of_week = Time.current.beginning_of_week
    end_of_week = Time.current.end_of_week
    trackings = ExerciseTracking
                .where(user_id: @user_id)
                .where(created_at: start_of_week..end_of_week).order(created_at: :desc)
    grouped = trackings.group_by { |tracking| tracking.created_at.strftime("%a") }

    daily_durations = grouped.transform_values do |sessions_on_day|
      times = sessions_on_day.map(&:created_at)
      duration = times.max - times.min # in seconds
      (duration / 60).to_i
    end
  end
end