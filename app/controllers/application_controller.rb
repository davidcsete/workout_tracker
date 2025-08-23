class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user!
  after_action :track_user_activity
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    if resource.user_detail.nil?
      new_user_detail_path
    else
      root_path
    end
  end

  private

  def track_user_activity
    return unless user_signed_in? && request.get? && !request.xhr?

    # Track page views for signed-in users
    UserActivity.track_user_activity(current_user, :page_view)
  rescue => e
    # Don't let tracking errors break the app
    Rails.logger.error "Failed to track user activity: #{e.message}"
  end
end
