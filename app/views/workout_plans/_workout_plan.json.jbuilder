json.extract! workout_plan, :id, :name, :user_id, :created_at, :updated_at
json.url workout_plan_url(workout_plan, format: :json)
