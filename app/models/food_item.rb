class FoodItem < ApplicationRecord
  belongs_to :meal
  belongs_to :food, optional: true

  before_save :populate_nutrients_from_food, if: -> { food.present? && (calories.nil? || protein.nil? || carbs.nil? || fats.nil?) }

  private

  def populate_nutrients_from_food
    self.calories = food.calories
    self.protein = food.protein
    self.carbs   = food.carbs
    self.fats    = food.fats
  end
end
