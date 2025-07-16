json.extract! meal, :id, :name, :meal_type, :consumed_at, :user_id, :created_at, :updated_at
json.url meal_url(meal, format: :json)
