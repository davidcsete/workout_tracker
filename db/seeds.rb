puts "Seeding database..."

# Destroy in proper order to avoid foreign key constraints
Recipe.destroy_all
RecipeIngredient.destroy_all
RecipeCopy.destroy_all
ExerciseTracking.destroy_all
WorkoutPlanExercise.destroy_all
WorkoutPlan.destroy_all
Exercise.destroy_all
FoodItem.destroy_all
Meal.destroy_all
Food.destroy_all
User.destroy_all
Goal.destroy_all
Lifestyle.destroy_all

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

# Comprehensive food database with nutritional values per 100g
Food.create!([
  # Proteins
  { name: "Chicken Breast", calories: 165, protein: 31.0, carbs: 0.0, fats: 3.6 },
  { name: "Salmon", calories: 208, protein: 20.4, carbs: 0.0, fats: 13.4 },
  { name: "Ground Beef (85% lean)", calories: 250, protein: 26.0, carbs: 0.0, fats: 15.0 },
  { name: "Eggs", calories: 155, protein: 13.0, carbs: 1.1, fats: 11.0 },
  { name: "Greek Yogurt (plain)", calories: 59, protein: 10.0, carbs: 3.6, fats: 0.4 },
  { name: "Tuna (canned in water)", calories: 116, protein: 25.5, carbs: 0.0, fats: 0.8 },
  { name: "Tofu", calories: 76, protein: 8.0, carbs: 1.9, fats: 4.8 },
  { name: "Cottage Cheese", calories: 98, protein: 11.1, carbs: 3.4, fats: 4.3 },

  # Carbohydrates
  { name: "Brown Rice", calories: 112, protein: 2.6, carbs: 23.0, fats: 0.9 },
  { name: "White Rice", calories: 130, protein: 2.7, carbs: 28.0, fats: 0.3 },
  { name: "Quinoa", calories: 120, protein: 4.4, carbs: 22.0, fats: 1.9 },
  { name: "Oats", calories: 389, protein: 16.9, carbs: 66.3, fats: 6.9 },
  { name: "Sweet Potato", calories: 86, protein: 1.6, carbs: 20.1, fats: 0.1 },
  { name: "Pasta (whole wheat)", calories: 131, protein: 5.0, carbs: 25.0, fats: 1.1 },
  { name: "Bread (whole wheat)", calories: 247, protein: 13.0, carbs: 41.0, fats: 4.2 },
  { name: "Banana", calories: 89, protein: 1.1, carbs: 22.8, fats: 0.3 },
  { name: "Apple", calories: 52, protein: 0.3, carbs: 13.8, fats: 0.2 },

  # Vegetables
  { name: "Broccoli", calories: 34, protein: 2.8, carbs: 7.0, fats: 0.4 },
  { name: "Spinach", calories: 23, protein: 2.9, carbs: 3.6, fats: 0.4 },
  { name: "Bell Pepper", calories: 31, protein: 1.0, carbs: 7.0, fats: 0.3 },
  { name: "Tomato", calories: 18, protein: 0.9, carbs: 3.9, fats: 0.2 },
  { name: "Onion", calories: 40, protein: 1.1, carbs: 9.3, fats: 0.1 },
  { name: "Garlic", calories: 149, protein: 6.4, carbs: 33.1, fats: 0.5 },
  { name: "Carrot", calories: 41, protein: 0.9, carbs: 9.6, fats: 0.2 },
  { name: "Cucumber", calories: 16, protein: 0.7, carbs: 4.0, fats: 0.1 },
  { name: "Lettuce", calories: 15, protein: 1.4, carbs: 2.9, fats: 0.2 },

  # Fats & Nuts
  { name: "Avocado", calories: 160, protein: 2.0, carbs: 8.5, fats: 14.7 },
  { name: "Almonds", calories: 579, protein: 21.2, carbs: 21.6, fats: 49.9 },
  { name: "Walnuts", calories: 654, protein: 15.2, carbs: 13.7, fats: 65.2 },
  { name: "Olive Oil", calories: 884, protein: 0.0, carbs: 0.0, fats: 100.0 },
  { name: "Coconut Oil", calories: 862, protein: 0.0, carbs: 0.0, fats: 100.0 },
  { name: "Peanut Butter", calories: 588, protein: 25.1, carbs: 19.6, fats: 50.4 },

  # Dairy
  { name: "Milk (whole)", calories: 61, protein: 3.2, carbs: 4.8, fats: 3.3 },
  { name: "Cheddar Cheese", calories: 403, protein: 25.0, carbs: 1.3, fats: 33.1 },
  { name: "Mozzarella", calories: 280, protein: 22.2, carbs: 2.2, fats: 17.1 },

  # Legumes
  { name: "Black Beans", calories: 132, protein: 8.9, carbs: 23.7, fats: 0.5 },
  { name: "Chickpeas", calories: 164, protein: 8.9, carbs: 27.4, fats: 2.6 },
  { name: "Lentils", calories: 116, protein: 9.0, carbs: 20.1, fats: 0.4 },

  # Condiments & Seasonings
  { name: "Salt", calories: 0, protein: 0.0, carbs: 0.0, fats: 0.0 },
  { name: "Black Pepper", calories: 251, protein: 10.4, carbs: 63.9, fats: 3.3 },
  { name: "Lemon Juice", calories: 22, protein: 0.4, carbs: 6.9, fats: 0.2 },
  { name: "Soy Sauce", calories: 8, protein: 1.3, carbs: 0.8, fats: 0.0 }
])

puts "Seeding recipes..."

# Destroy existing recipes to avoid duplicates
Recipe.destroy_all
RecipeIngredient.destroy_all
RecipeCopy.destroy_all

# Create sample recipes with realistic ingredients and nutritional values
recipes_data = [
  {
    name: "Grilled Chicken & Quinoa Bowl",
    description: "A nutritious and protein-packed meal perfect for post-workout recovery",
    instructions: "1. Season chicken breast with salt and pepper\n2. Grill chicken for 6-7 minutes per side until cooked through\n3. Cook quinoa according to package directions\n4. Steam broccoli for 5 minutes until tender\n5. Slice avocado and arrange all ingredients in a bowl\n6. Drizzle with olive oil and lemon juice",
    servings: 2,
    prep_time_minutes: 15,
    cook_time_minutes: 20,
    public: true,
    user: users.first,
    # Calculated totals: 1,142 calories, 106.8g protein, 67.8g carbs, 47.4g fats
    total_calories: 1142.0,
    total_protein: 106.8,
    total_carbs: 67.8,
    total_fats: 47.4,
    ingredients: [
      { food: "Chicken Breast", quantity: 300, unit: "grams" },
      { food: "Quinoa", quantity: 150, unit: "grams" },
      { food: "Broccoli", quantity: 200, unit: "grams" },
      { food: "Avocado", quantity: 100, unit: "grams" },
      { food: "Olive Oil", quantity: 15, unit: "grams" },
      { food: "Lemon Juice", quantity: 30, unit: "grams" },
      { food: "Salt", quantity: 2, unit: "grams" }
    ]
  },
  {
    name: "Salmon Teriyaki with Brown Rice",
    description: "Delicious Asian-inspired salmon with perfectly seasoned brown rice",
    instructions: "1. Marinate salmon in soy sauce for 15 minutes\n2. Cook brown rice according to package directions\n3. Heat olive oil in a pan over medium heat\n4. Cook salmon for 4-5 minutes per side\n5. Sauté bell peppers and onions until tender\n6. Serve salmon over rice with vegetables",
    servings: 3,
    prep_time_minutes: 20,
    cook_time_minutes: 25,
    public: true,
    user: users.second,
    # Calculated totals: 1,334 calories, 87.9g protein, 56.4g carbs, 64.2g fats
    total_calories: 1334.0,
    total_protein: 87.9,
    total_carbs: 56.4,
    total_fats: 64.2,
    ingredients: [
      { food: "Salmon", quantity: 400, unit: "grams" },
      { food: "Brown Rice", quantity: 200, unit: "grams" },
      { food: "Bell Pepper", quantity: 150, unit: "grams" },
      { food: "Onion", quantity: 100, unit: "grams" },
      { food: "Soy Sauce", quantity: 30, unit: "grams" },
      { food: "Olive Oil", quantity: 10, unit: "grams" }
    ]
  },
  {
    name: "Mediterranean Chickpea Salad",
    description: "Fresh and vibrant salad packed with plant-based protein and Mediterranean flavors",
    instructions: "1. Drain and rinse chickpeas\n2. Dice tomatoes, cucumber, and onion\n3. Crumble mozzarella cheese\n4. Mix all vegetables and chickpeas in a large bowl\n5. Whisk olive oil, lemon juice, salt, and pepper for dressing\n6. Toss salad with dressing and let marinate for 10 minutes",
    servings: 4,
    prep_time_minutes: 15,
    cook_time_minutes: 0,
    public: true,
    user: users.third,
    # Calculated totals: 1,051 calories, 49.1g protein, 95.7g carbs, 42.8g fats
    total_calories: 1051.0,
    total_protein: 49.1,
    total_carbs: 95.7,
    total_fats: 42.8,
    ingredients: [
      { food: "Chickpeas", quantity: 300, unit: "grams" },
      { food: "Tomato", quantity: 200, unit: "grams" },
      { food: "Cucumber", quantity: 150, unit: "grams" },
      { food: "Onion", quantity: 50, unit: "grams" },
      { food: "Mozzarella", quantity: 100, unit: "grams" },
      { food: "Olive Oil", quantity: 20, unit: "grams" },
      { food: "Lemon Juice", quantity: 15, unit: "grams" },
      { food: "Salt", quantity: 2, unit: "grams" },
      { food: "Black Pepper", quantity: 1, unit: "grams" }
    ]
  },
  {
    name: "Protein-Packed Breakfast Bowl",
    description: "Start your day right with this nutrient-dense breakfast combination",
    instructions: "1. Cook oats with milk until creamy\n2. Scramble eggs with a little olive oil\n3. Slice banana and prepare berries\n4. Layer oats in bowl, top with scrambled eggs\n5. Add sliced banana and berries\n6. Sprinkle with almonds and a drizzle of honey",
    servings: 1,
    prep_time_minutes: 5,
    cook_time_minutes: 10,
    public: false,
    user: users.fourth,
    # Calculated totals: 736 calories, 35.9g protein, 67.5g carbs, 33.4g fats
    total_calories: 736.0,
    total_protein: 35.9,
    total_carbs: 67.5,
    total_fats: 33.4,
    ingredients: [
      { food: "Oats", quantity: 50, unit: "grams" },
      { food: "Milk (whole)", quantity: 200, unit: "grams" },
      { food: "Eggs", quantity: 100, unit: "grams" },
      { food: "Banana", quantity: 120, unit: "grams" },
      { food: "Almonds", quantity: 20, unit: "grams" },
      { food: "Olive Oil", quantity: 5, unit: "grams" }
    ]
  },
  {
    name: "Beef & Sweet Potato Stir Fry",
    description: "Hearty and satisfying stir fry perfect for muscle building",
    instructions: "1. Cut beef into strips and season with salt and pepper\n2. Cube sweet potatoes and steam for 8 minutes\n3. Heat olive oil in a large pan or wok\n4. Stir fry beef for 3-4 minutes until browned\n5. Add sweet potatoes, bell peppers, and onions\n6. Stir fry for 5-6 minutes until vegetables are tender\n7. Season with garlic and serve hot",
    servings: 3,
    prep_time_minutes: 15,
    cook_time_minutes: 18,
    public: true,
    user: users.fifth,
    # Calculated totals: 1,374 calories, 93.9g protein, 75.4g carbs, 65.8g fats
    total_calories: 1374.0,
    total_protein: 93.9,
    total_carbs: 75.4,
    total_fats: 65.8,
    ingredients: [
      { food: "Ground Beef (85% lean)", quantity: 350, unit: "grams" },
      { food: "Sweet Potato", quantity: 300, unit: "grams" },
      { food: "Bell Pepper", quantity: 150, unit: "grams" },
      { food: "Onion", quantity: 100, unit: "grams" },
      { food: "Garlic", quantity: 10, unit: "grams" },
      { food: "Olive Oil", quantity: 15, unit: "grams" },
      { food: "Salt", quantity: 2, unit: "grams" },
      { food: "Black Pepper", quantity: 1, unit: "grams" }
    ]
  },
  {
    name: "Tuna & White Bean Salad",
    description: "Light yet filling salad perfect for lunch or a quick dinner",
    instructions: "1. Drain tuna and white beans\n2. Dice tomatoes and cucumber\n3. Thinly slice onion\n4. Combine all ingredients in a large bowl\n5. Dress with olive oil, lemon juice, salt, and pepper\n6. Toss well and let flavors meld for 5 minutes",
    servings: 2,
    prep_time_minutes: 10,
    cook_time_minutes: 0,
    public: true,
    user: users[5],
    # Calculated totals: 587 calories, 64.9g protein, 51.4g carbs, 16.2g fats
    total_calories: 587.0,
    total_protein: 64.9,
    total_carbs: 51.4,
    total_fats: 16.2,
    ingredients: [
      { food: "Tuna (canned in water)", quantity: 200, unit: "grams" },
      { food: "Black Beans", quantity: 150, unit: "grams" },
      { food: "Tomato", quantity: 150, unit: "grams" },
      { food: "Cucumber", quantity: 100, unit: "grams" },
      { food: "Onion", quantity: 30, unit: "grams" },
      { food: "Olive Oil", quantity: 15, unit: "grams" },
      { food: "Lemon Juice", quantity: 10, unit: "grams" }
    ]
  },
  {
    name: "Veggie-Packed Tofu Scramble",
    description: "Plant-based protein scramble loaded with colorful vegetables",
    instructions: "1. Crumble tofu into bite-sized pieces\n2. Heat olive oil in a large pan\n3. Sauté onions and bell peppers until soft\n4. Add spinach and cook until wilted\n5. Add crumbled tofu and cook for 5 minutes\n6. Season with salt, pepper, and garlic\n7. Serve hot with whole wheat toast",
    servings: 2,
    prep_time_minutes: 10,
    cook_time_minutes: 12,
    public: true,
    user: users[6],
    # Calculated totals: 484 calories, 28.1g protein, 42.8g carbs, 24.7g fats
    total_calories: 484.0,
    total_protein: 28.1,
    total_carbs: 42.8,
    total_fats: 24.7,
    ingredients: [
      { food: "Tofu", quantity: 250, unit: "grams" },
      { food: "Spinach", quantity: 100, unit: "grams" },
      { food: "Bell Pepper", quantity: 100, unit: "grams" },
      { food: "Onion", quantity: 80, unit: "grams" },
      { food: "Garlic", quantity: 8, unit: "grams" },
      { food: "Olive Oil", quantity: 12, unit: "grams" },
      { food: "Bread (whole wheat)", quantity: 60, unit: "grams" }
    ]
  },
  {
    name: "Classic Greek Yogurt Parfait",
    description: "Creamy, protein-rich parfait perfect for breakfast or snack",
    instructions: "1. Layer Greek yogurt in a glass or bowl\n2. Add a layer of mixed berries\n3. Sprinkle with almonds and walnuts\n4. Repeat layers as desired\n5. Top with a drizzle of honey if desired\n6. Serve immediately for best texture",
    servings: 1,
    prep_time_minutes: 5,
    cook_time_minutes: 0,
    public: false,
    user: users[7],
    # Calculated totals: 357 calories, 24.7g protein, 17.6g carbs, 23.0g fats
    total_calories: 357.0,
    total_protein: 24.7,
    total_carbs: 17.6,
    total_fats: 23.0,
    ingredients: [
      { food: "Greek Yogurt (plain)", quantity: 200, unit: "grams" },
      { food: "Apple", quantity: 100, unit: "grams" },
      { food: "Almonds", quantity: 15, unit: "grams" },
      { food: "Walnuts", quantity: 10, unit: "grams" }
    ]
  },
  {
    name: "Hearty Lentil & Vegetable Soup",
    description: "Warming, nutritious soup packed with plant-based protein and fiber",
    instructions: "1. Heat olive oil in a large pot\n2. Sauté onions, carrots, and garlic until fragrant\n3. Add lentils and enough water to cover by 2 inches\n4. Bring to a boil, then simmer for 20 minutes\n5. Add diced tomatoes and spinach\n6. Season with salt and pepper\n7. Simmer 5 more minutes until lentils are tender",
    servings: 4,
    prep_time_minutes: 15,
    cook_time_minutes: 30,
    public: true,
    user: users[8],
    # Calculated totals: 529 calories, 24.4g protein, 85.2g carbs, 15.4g fats
    total_calories: 529.0,
    total_protein: 24.4,
    total_carbs: 85.2,
    total_fats: 15.4,
    ingredients: [
      { food: "Lentils", quantity: 200, unit: "grams" },
      { food: "Carrot", quantity: 150, unit: "grams" },
      { food: "Onion", quantity: 100, unit: "grams" },
      { food: "Spinach", quantity: 100, unit: "grams" },
      { food: "Tomato", quantity: 200, unit: "grams" },
      { food: "Garlic", quantity: 10, unit: "grams" },
      { food: "Olive Oil", quantity: 15, unit: "grams" },
      { food: "Salt", quantity: 3, unit: "grams" }
    ]
  },
  {
    name: "Cottage Cheese Power Bowl",
    description: "High-protein bowl perfect for muscle recovery and satiety",
    instructions: "1. Place cottage cheese in a bowl as the base\n2. Slice banana and arrange on top\n3. Add a handful of spinach leaves\n4. Sprinkle with almonds and walnuts\n5. Drizzle with a small amount of olive oil\n6. Season with black pepper to taste",
    servings: 1,
    prep_time_minutes: 5,
    cook_time_minutes: 0,
    public: false,
    user: users[9],
    # Calculated totals: 565 calories, 32.8g protein, 33.2g carbs, 35.4g fats
    total_calories: 565.0,
    total_protein: 32.8,
    total_carbs: 33.2,
    total_fats: 35.4,
    ingredients: [
      { food: "Cottage Cheese", quantity: 200, unit: "grams" },
      { food: "Banana", quantity: 120, unit: "grams" },
      { food: "Spinach", quantity: 50, unit: "grams" },
      { food: "Almonds", quantity: 20, unit: "grams" },
      { food: "Walnuts", quantity: 15, unit: "grams" },
      { food: "Olive Oil", quantity: 5, unit: "grams" },
      { food: "Black Pepper", quantity: 0.5, unit: "grams" }
    ]
  }
]

# Create recipes with ingredients
recipes_data.each do |recipe_data|
  recipe = Recipe.create!(
    name: recipe_data[:name],
    description: recipe_data[:description],
    instructions: recipe_data[:instructions],
    servings: recipe_data[:servings],
    prep_time_minutes: recipe_data[:prep_time_minutes],
    cook_time_minutes: recipe_data[:cook_time_minutes],
    public: recipe_data[:public],
    user: recipe_data[:user],
    total_calories: recipe_data[:total_calories],
    total_protein: recipe_data[:total_protein],
    total_carbs: recipe_data[:total_carbs],
    total_fats: recipe_data[:total_fats]
  )

  # Add ingredients to the recipe
  recipe_data[:ingredients].each_with_index do |ingredient_data, index|
    food = Food.find_by(name: ingredient_data[:food])
    if food
      RecipeIngredient.create!(
        recipe: recipe,
        food: food,
        quantity: ingredient_data[:quantity],
        unit: ingredient_data[:unit],
        order_index: index
      )
    else
      puts "⚠️  Warning: Food '#{ingredient_data[:food]}' not found for recipe '#{recipe.name}'"
    end
  end

  puts "✅ Created recipe: #{recipe.name} (#{recipe.recipe_ingredients.count} ingredients)"
end

# Create some recipe copies to demonstrate the copying feature
public_recipes = Recipe.where(public: true).limit(3)
copy_users = users.last(3)

public_recipes.each_with_index do |original_recipe, index|
  copying_user = copy_users[index]
  next if original_recipe.user == copying_user

  # Create a copied recipe
  copied_recipe = original_recipe.dup
  copied_recipe.user = copying_user
  copied_recipe.public = false
  copied_recipe.name = "#{original_recipe.name} (My Copy)"

  if copied_recipe.save
    # Copy all ingredients
    original_recipe.recipe_ingredients.each do |ingredient|
      RecipeIngredient.create!(
        recipe: copied_recipe,
        food: ingredient.food,
        quantity: ingredient.quantity,
        unit: ingredient.unit,
        order_index: ingredient.order_index
      )
    end

    # Create the copy relationship
    RecipeCopy.create!(
      user: copying_user,
      original_recipe: original_recipe,
      copied_recipe: copied_recipe
    )

    puts "✅ #{copying_user.username} copied '#{original_recipe.name}'"
  end
end

puts "📊 Recipe seeding complete!"
puts "   - Created #{Recipe.count} recipes"
puts "   - Created #{RecipeIngredient.count} recipe ingredients"
puts "   - Created #{RecipeCopy.count} recipe copies"
puts "   - Public recipes: #{Recipe.where(public: true).count}"
puts "   - Private recipes: #{Recipe.where(public: false).count}"

puts "✅ Done seeding!"
