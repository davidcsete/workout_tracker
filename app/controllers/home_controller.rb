class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    today_macros
  end

  private

  def today_macros
    meals_today = current_user.meals.where(created_at: Time.zone.today.all_day)

    totals = meals_today.joins(:food_items).select(
      "SUM(food_items.calories) as total_calories",
      "SUM(food_items.protein) as total_protein",
      "SUM(food_items.carbs) as total_carbs",
      "SUM(food_items.fats) as total_fats"
    ).take

    @total_calories = totals.total_calories.to_i
    @macros = {
      protein: totals.total_protein.to_f,
      carbs: totals.total_carbs.to_f,
      fats: totals.total_fats.to_f
    }
  end
end
