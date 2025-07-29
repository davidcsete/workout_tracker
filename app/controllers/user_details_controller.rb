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
      # Update user gender
      current_user.update(gender: params[:gender])
      
      # Create automatic diet goal
      diet_goal = DietGoal.generate_for_user(current_user)
      diet_goal.save if diet_goal
      
      redirect_to diet_goals_path, notice: "Welcome! Your profile and nutrition goals are set up."
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
