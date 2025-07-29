class DietGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_diet_goal, only: [ :show, :edit, :update ]

  def index
    @diet_goal = current_user.diet_goal
    redirect_to new_diet_goal_path unless @diet_goal
  end

  def show
  end

  def new
    @diet_goal = current_user.build_diet_goal
  end

  def create
    @diet_goal = current_user.build_diet_goal(diet_goal_params)
    @diet_goal.is_custom = true

    if @diet_goal.save
      redirect_to diet_goals_path, notice: "Your custom diet goal has been created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @diet_goal.is_custom = true

    if @diet_goal.update(diet_goal_params)
      redirect_to diet_goals_path, notice: "Your diet goal has been updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def regenerate
    @diet_goal = current_user.diet_goal
    if @diet_goal
      new_goal = DietGoal.generate_for_user(current_user)
      @diet_goal.update(
        daily_calories: new_goal.daily_calories,
        protein_percentage: new_goal.protein_percentage,
        carb_percentage: new_goal.carb_percentage,
        fat_percentage: new_goal.fat_percentage,
        weight_change_per_week: new_goal.weight_change_per_week,
        is_custom: false
      )
      redirect_to diet_goals_path, notice: "Your diet goal has been regenerated based on your current profile!"
    else
      redirect_to new_diet_goal_path
    end
  end

  private

  def set_diet_goal
    @diet_goal = current_user.diet_goal
    redirect_to new_diet_goal_path unless @diet_goal
  end

  def diet_goal_params
    params.require(:diet_goal).permit(:daily_calories, :protein_percentage, :carb_percentage, :fat_percentage, :weight_change_per_week)
  end
end
