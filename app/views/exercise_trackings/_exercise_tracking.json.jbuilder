json.extract! exercise_tracking, :id, :user_id, :exercise_id, :reps, :weight, :performed_at, :created_at, :updated_at
json.url exercise_tracking_url(exercise_tracking, format: :json)
