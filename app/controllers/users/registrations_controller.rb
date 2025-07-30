class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [ :update ]

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    # Store previous goal to check if it changed
    previous_goal_id = resource.user_detail&.goal_id

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)

      # Check if goal changed and recalculate diet goals
      current_goal_id = resource.user_detail&.goal_id
      if previous_goal_id != current_goal_id && resource.diet_goal.present?
        recalculate_diet_goals(resource)
        flash[:notice] = "#{flash[:notice]} Your calorie goals have been automatically updated based on your new fitness goal."
      end

      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      user_detail_attributes: [ :id, :age, :bodyweight, :goal_id, :lifestyle_id ]
    ])
  end

  def update_resource(resource, params)
    # Remove password params if they're blank
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  private

  def recalculate_diet_goals(user)
    return unless user.diet_goal

    new_goal = DietGoal.generate_for_user(user)
    user.diet_goal.update(
      daily_calories: new_goal.daily_calories,
      protein_percentage: new_goal.protein_percentage,
      carb_percentage: new_goal.carb_percentage,
      fat_percentage: new_goal.fat_percentage,
      weight_change_per_week: new_goal.weight_change_per_week,
      is_custom: false
    )
  end
end
