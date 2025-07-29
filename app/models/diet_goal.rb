class DietGoal < ApplicationRecord
  belongs_to :user

  validates :daily_calories, presence: true, numericality: { greater_than: 0 }
  validates :protein_percentage, presence: true, numericality: { in: 0..100 }
  validates :carb_percentage, presence: true, numericality: { in: 0..100 }
  validates :fat_percentage, presence: true, numericality: { in: 0..100 }
  validates :weight_change_per_week, presence: true, numericality: true
  validate :percentages_sum_to_100

  # Calculate macros in grams based on calories and percentages
  def protein_grams
    (daily_calories * protein_percentage / 100 / 4).round(1) # 4 calories per gram of protein
  end

  def carb_grams
    (daily_calories * carb_percentage / 100 / 4).round(1) # 4 calories per gram of carbs
  end

  def fat_grams
    (daily_calories * fat_percentage / 100 / 9).round(1) # 9 calories per gram of fat
  end

  # Generate automatic diet goal based on user details and goal
  def self.generate_for_user(user)
    user_detail = user.user_detail
    return nil unless user_detail

    # Calculate BMR using Mifflin-St Jeor Equation
    if user.gender == "male"
      bmr = (10 * user_detail.bodyweight) + (6.25 * user_detail.height) - (5 * user_detail.age) + 5
    else
      bmr = (10 * user_detail.bodyweight) + (6.25 * user_detail.height) - (5 * user_detail.age) - 161
    end

    # Apply activity multiplier based on lifestyle
    activity_multiplier = case user_detail.lifestyle.name.downcase
    when /sedentary/
                           1.2
    when /slightly active/
                           1.375
    when /active/
                           1.55
    else
                           1.375 # default to lightly active
    end

    tdee = bmr * activity_multiplier

    # Adjust calories based on goal
    weight_change_per_week = case user_detail.goal.goal_type
    when "lose_weight"
                              -0.5 # lose 0.5kg per week
    when "gain_weight_and_build_muscle"
                              0.3 # gain 0.3kg per week
    when "lose_weight_and_build_muscle"
                              -0.3 # lose 0.3kg per week (slower for muscle preservation)
    else
                              0 # maintenance
    end

    # 1kg of fat = ~7700 calories, so weekly deficit/surplus needed
    weekly_calorie_adjustment = weight_change_per_week * 7700
    daily_calorie_adjustment = weekly_calorie_adjustment / 7

    target_calories = (tdee + daily_calorie_adjustment).round

    # Set macro percentages based on goal
    protein_pct, carb_pct, fat_pct = case user_detail.goal.goal_type
    when "lose_weight", "lose_weight_and_build_muscle"
                                      [ 30, 40, 30 ] # Higher protein for muscle preservation
    when "build_muscle", "gain_weight_and_build_muscle"
                                      [ 25, 45, 30 ] # Moderate protein, higher carbs for energy
    when "get_stronger", "get_stronger_and_build_more_muscle"
                                      [ 25, 50, 25 ] # Higher carbs for performance
    else
                                      [ 20, 50, 30 ] # Balanced approach
    end

    new(
      user: user,
      daily_calories: target_calories,
      protein_percentage: protein_pct,
      carb_percentage: carb_pct,
      fat_percentage: fat_pct,
      weight_change_per_week: weight_change_per_week,
      is_custom: false
    )
  end

  private

  def percentages_sum_to_100
    total = protein_percentage + carb_percentage + fat_percentage
    errors.add(:base, "Macro percentages must sum to 100%") unless total == 100
  end
end
