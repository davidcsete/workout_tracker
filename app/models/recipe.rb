class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients, -> { order(:order_index) }, dependent: :destroy
  has_many :foods, through: :recipe_ingredients
  has_many :recipe_copies, foreign_key: :original_recipe_id, dependent: :destroy
  has_many :copied_recipes, through: :recipe_copies

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :servings, presence: true, numericality: { greater_than: 0 }

  scope :public_recipes, -> { where(public: true) }
  scope :by_user, ->(user) { where(user: user) }

  before_save :calculate_totals

  def per_serving_calories
    return 0 if servings.zero?
    (total_calories || 0) / servings
  end

  def per_serving_protein
    return 0 if servings.zero?
    (total_protein || 0) / servings
  end

  def per_serving_carbs
    return 0 if servings.zero?
    (total_carbs || 0) / servings
  end

  def per_serving_fats
    return 0 if servings.zero?
    (total_fats || 0) / servings
  end

  def total_grams
    recipe_ingredients.sum { |ri| ri.quantity || 0 }
  end

  def per_serving_grams
    return 0 if servings.zero?
    total_grams / servings
  end

  def total_time_minutes
    (prep_time_minutes || 0) + (cook_time_minutes || 0)
  end

  def can_be_copied_by?(user)
    public? && self.user != user
  end

  def copied_by?(user)
    recipe_copies.exists?(user: user)
  end

  private

  def calculate_totals
    # Only calculate if totals are not already set (e.g., from seeds or manual entry)
    return if total_calories.present? && total_protein.present? && total_carbs.present? && total_fats.present?
    
    self.total_calories = recipe_ingredients.sum { |ri| (ri.food.calories || 0) * (ri.quantity || 0) / 100 }
    self.total_protein = recipe_ingredients.sum { |ri| (ri.food.protein || 0) * (ri.quantity || 0) / 100 }
    self.total_carbs = recipe_ingredients.sum { |ri| (ri.food.carbs || 0) * (ri.quantity || 0) / 100 }
    self.total_fats = recipe_ingredients.sum { |ri| (ri.food.fats || 0) * (ri.quantity || 0) / 100 }
  end
end
