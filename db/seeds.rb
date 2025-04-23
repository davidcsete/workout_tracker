puts "Seeding database..."

User.destroy_all
WorkoutPlan.destroy_all
Exercise.destroy_all
Weekday.destroy_all
ExerciseTracking.destroy_all

# Admin user
admin = User.create!(email: "admin@example.com", password: "password", username: "Admin", admin: true)

# Regular users
users = 5.times.map do |i|
  User.create!(
    email: "user#{i}@example.com",
    password: "password",
    username: "User#{i}"
  )
end

# Weekdays
weekdays = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].map do |name|
  Weekday.create!(name: name)
end

# Realistic Exercises with links
exercise_data = [
  ["Push-up", "https://exrx.net/WeightExercises/PectoralSternal/BWPushup"],
  ["Squat", "https://exrx.net/WeightExercises/Quadriceps/BWSquat"],
  ["Deadlift", "https://exrx.net/WeightExercises/ErectorSpinae/BBDeadlift"],
  ["Bench Press", "https://exrx.net/WeightExercises/PectoralSternal/BBBenchPress"],
  ["Pull-up", "https://exrx.net/WeightExercises/LatissimusDorsi/BWPullup"],
  ["Bicep Curl", "https://exrx.net/WeightExercises/Biceps/DBCurl"],
  ["Overhead Press", "https://exrx.net/WeightExercises/DeltoidAnterior/BBMilitaryPress"],
  ["Lunges", "https://exrx.net/WeightExercises/Quadriceps/BBLunge"],
  ["Plank", "https://exrx.net/WeightExercises/RectusAbdominis/BWPlank"],
  ["Row", "https://exrx.net/WeightExercises/BackGeneral/BBBentOverRow"]
]

exercises = exercise_data.map do |name, description|
  Exercise.create!(name: name, description: description)
end

# Custom names for workout plans
custom_plan_names = [
  "Full Body Burn",
  "Strength & Power",
  "Lean & Mean",
  "Core Crusher",
  "Push Pull Legs",
  "HIIT & Sweat",
  "Muscle Builder",
  "Endurance Boost",
  "Upper Body Focus",
  "Leg Day Supreme"
]

# Workout plans and associations
users.each do |user|
  2.times do
    plan_name = custom_plan_names.sample
    plan = WorkoutPlan.create!(name: plan_name, user: user)

    exercises.sample(5).each do |exercise|
      plan.exercises << exercise
      exercise.weekdays << weekdays.sample(2)
    end

    # Add tracking data
    plan.exercises.each do |exercise|
      3.times do
        ExerciseTracking.create!(
          exercise: exercise,
          user: user,
          reps: rand(6..15),
          weight: rand(20..100),
          created_at: Faker::Time.backward(days: 14, period: :evening)
        )
      end
    end
  end
end

puts "✅ Done seeding!"