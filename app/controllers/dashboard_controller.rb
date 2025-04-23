class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @recent_tracking = current_user.exercise_trackings.order(created_at: :desc).limit(10)
  end
end
