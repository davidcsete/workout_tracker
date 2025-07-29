puts "Seeding database..."

WorkoutPlan.destroy_all
User.destroy_all
Exercise.destroy_all
Weekday.destroy_all
ExerciseTracking.destroy_all
Goal.destroy_all
Lifestyle.destroy_all
Meal.destroy_all
FoodItem.destroy_all
Food.destroy_all

# Admin user
admin = User.create!(email: "admin@example.com", password: "password", username: "Admin", admin: true)

# Regular users
users = 10.times.map do |i|
  User.create!(
    email: "user#{i}@example.com",
    password: "password",
    username: "User#{i}"
  )
end

# Weekdays
weekdays = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

# Realistic Exercises with links
exercise_data = [
  [ "Push-up", "https://exrx.net/WeightExercises/PectoralSternal/BWPushup" ],
  [ "Squat", "https://exrx.net/WeightExercises/Quadriceps/BWSquat" ],
  [ "Deadlift", "https://exrx.net/WeightExercises/ErectorSpinae/BBDeadlift" ],
  [ "Bench Press", "https://exrx.net/WeightExercises/PectoralSternal/BBBenchPress" ],
  [ "Pull-up", "https://exrx.net/WeightExercises/LatissimusDorsi/BWPullup" ],
  [ "Bicep Curl", "https://exrx.net/WeightExercises/Biceps/DBCurl" ],
  [ "Overhead Press", "https://exrx.net/WeightExercises/DeltoidAnterior/BBMilitaryPress" ],
  [ "Lunges", "https://exrx.net/WeightExercises/Quadriceps/BBLunge" ],
  [ "Plank", "https://exrx.net/WeightExercises/RectusAbdominis/BWPlank" ],
  [ "Row", "https://exrx.net/WeightExercises/BackGeneral/BBBentOverRow" ],
  [ "Leg Press", "https://exrx.net/WeightExercises/Quadriceps/LVLegPress" ],
  [ "Cable Crossover", "https://exrx.net/WeightExercises/PectoralSternal/CBCrossover" ],
  [ "Lat Pulldown", "https://exrx.net/WeightExercises/LatissimusDorsi/CBLatPulldown" ],
  [ "Tricep Extension", "https://exrx.net/WeightExercises/Triceps/DBTriExt" ],
  [ "Crunches", "https://exrx.net/WeightExercises/RectusAbdominis/BWCrunch" ]
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
  plan_name = custom_plan_names.sample
  plan = WorkoutPlan.create!(name: plan_name, user: user)

  15.times do |index|
    exercise = exercises.sample
    weekday = weekdays.sample
    WorkoutPlanExercise.create!(
      workout_plan: plan,
      exercise: exercise,
      day_of_the_week: weekdays.index(weekday),
      order: index + 1
    )
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

Goal.create!([
  { name: "Lose weight", goal_type: :lose_weight },
  { name: "Build muscle", goal_type: :build_muscle },
  { name: "Lose weight and build muscle", goal_type: :lose_weight_and_build_muscle },
  { name: "Be more active", goal_type: :be_more_active },
  { name: "Gain weight and build muscle", goal_type: :gain_weight_and_build_muscle },
  { name: "Get stronger", goal_type: :get_stronger },
  { name: "Get stronger and build more muscle", goal_type: :get_stronger_and_build_more_muscle }
])

Lifestyle.create!([
  { name: "Active", description: "Workout 5 times per week" },
  { name: "Slightly active", description: "Workout 3 times per week" },
  { name: "Sedentary", description: "No workout or works out 1-2 times a week" }
])

puts "Seeding meals and food items..."

# Example for the first user
calorie_user = users.first

# Define meal types for readability
meal_types = { breakfast: 0, lunch: 1, dinner: 2, snack: 3 }

# Helper to create meals with food items
def create_meal_for(user, type, time, items)
  meal = Meal.create!(
    user: user,
    name: "#{type.to_s.capitalize} - #{time.strftime("%b %d")}",
    meal_type: type,
    consumed_at: time
  )

  items.each do |item|
    FoodItem.create!(
      meal: meal,
      name: item[:name],
      calories: item[:calories],
      protein: item[:protein],
      carbs: item[:carbs],
      fats: item[:fats],
      grams: 100,
      consumed_at: time
    )
  end
end

now = Time.zone.now

create_meal_for(calorie_user, meal_types[:breakfast], now.beginning_of_day + 8.hours, [
  { name: "Oatmeal", calories: 150, protein: 5.0, carbs: 27.0, fats: 3.0 },
  { name: "Banana", calories: 90, protein: 1.0, carbs: 23.0, fats: 0.3 }
])

create_meal_for(calorie_user, meal_types[:lunch], now.beginning_of_day + 13.hours, [
  { name: "Grilled Chicken", calories: 250, protein: 30.0, carbs: 0.0, fats: 12.0 },
  { name: "Sweet Potato", calories: 180, protein: 3.0, carbs: 41.0, fats: 0.2 }
])

create_meal_for(calorie_user, meal_types[:dinner], now.beginning_of_day + 19.hours, [
  { name: "Salmon", calories: 300, protein: 34.0, carbs: 0.0, fats: 18.0 },
  { name: "Steamed Broccoli", calories: 55, protein: 4.0, carbs: 11.0, fats: 0.5 }
])

create_meal_for(calorie_user, meal_types[:snack], now.beginning_of_day + 16.hours, [
  { name: "Protein Bar", calories: 200, protein: 20.0, carbs: 15.0, fats: 7.0 }
])

Food.create!([
  { name: "Grilled Chicken Breast", calories: 165, protein: 31, carbs: 0, fats: 3.6 },
  { name: "Boiled Egg", calories: 78, protein: 6.3, carbs: 0.6, fats: 5.3 },
  { name: "Brown Rice (1 cup)", calories: 216, protein: 5, carbs: 44, fats: 1.8 },
  { name: "Broccoli (1 cup)", calories: 55, protein: 3.7, carbs: 11.2, fats: 0.6 },
  { name: "Almonds (28g)", calories: 164, protein: 6, carbs: 6, fats: 14 },
  { name: "Greek Yogurt (plain)", calories: 100, protein: 10, carbs: 3, fats: 0 },
  { name: "Salmon (100g)", calories: 208, protein: 20, carbs: 0, fats: 13 },
  { name: "Banana", calories: 105, protein: 1.3, carbs: 27, fats: 0.3 },
  { name: "Oats (1/2 cup)", calories: 150, protein: 5, carbs: 27, fats: 3 },
  { name: "Avocado (1/2)", calories: 120, protein: 1.5, carbs: 6, fats: 10 }
])

puts "✅ Done seeding!"
