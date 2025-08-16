class FoodItem < ApplicationRecord
  belongs_to :meal
  belongs_to :food, optional: true
  belongs_to :recipe, optional: true

  validates :consumed_at, presence: true

  before_save :populate_nutrients_from_food, if: -> { food.present? && (calories.nil? || protein.nil? || carbs.nil? || fats.nil?) }
  before_save :populate_nutrients_from_recipe, if: -> { recipe.present? && (calories.nil? || protein.nil? || carbs.nil? || fats.nil?) }

  private

  def populate_nutrients_from_food
    self.calories = food.calories
    self.protein = food.protein
    self.carbs   = food.carbs
    self.fats    = food.fats
  end

  def populate_nutrients_from_recipe
    servings = recipe_servings || 1
    self.calories = recipe.per_serving_calories * servings
    self.protein = recipe.per_serving_protein * servings
    self.carbs = recipe.per_serving_carbs * servings
    self.fats = recipe.per_serving_fats * servings
  end
end
