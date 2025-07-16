class Meal < ApplicationRecord
  belongs_to :user
  has_many :food_items, dependent: :destroy

  enum :meal_type, { breakfast: 0, lunch: 1, dinner: 2, snack: 3 }
end
