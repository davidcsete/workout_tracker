class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    if resource.user_detail.nil?
      new_user_detail_path
    else
      workout_plans_path
    end
  end
end
