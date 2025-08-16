class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :food

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true

  UNITS = %w[grams kilograms ounces pounds cups tablespoons teaspoons pieces].freeze

  validates :unit, inclusion: { in: UNITS }

  scope :ordered, -> { order(:order_index) }

  def calories_contribution
    (food.calories || 0) * quantity / 100
  end

  def protein_contribution
    (food.protein || 0) * quantity / 100
  end

  def carbs_contribution
    (food.carbs || 0) * quantity / 100
  end

  def fats_contribution
    (food.fats || 0) * quantity / 100
  end
end
