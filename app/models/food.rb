class Food < ApplicationRecord
  has_many :food_items, dependent: :destroy
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }

  scope :search_by_name, ->(query) { where("name ILIKE ?", "%#{query}%") }
end
