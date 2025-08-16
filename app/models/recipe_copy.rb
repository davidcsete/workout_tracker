class RecipeCopy < ApplicationRecord
  belongs_to :user
  belongs_to :original_recipe, class_name: "Recipe"
  belongs_to :copied_recipe, class_name: "Recipe"

  validates :user_id, uniqueness: { scope: :original_recipe_id }
end
