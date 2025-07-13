class UserDetailsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user_detail = UserDetail.new
    @goals = Goal.all
    @lifestyles = Lifestyle.all
  end

  def create
    @user_detail = current_user.build_user_detail(user_detail_params)

    if @user_detail.save
      redirect_to workout_plans_path, notice: "Welcome! Your profile is set up."
    else
      @goals = Goal.all
      @lifestyles = Lifestyle.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_detail_params
    params.require(:user_detail).permit(:age, :height, :bodyweight, :goal_id, :lifestyle_id)
  end
end
