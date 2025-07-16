json.extract! food_item, :id, :name, :calories, :protein, :carbs, :fats, :meal_id, :created_at, :updated_at
json.url food_item_url(food_item, format: :json)
