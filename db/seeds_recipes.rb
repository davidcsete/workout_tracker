# Create some sample foods if they don't exist
foods = [
  { name: "Chicken Breast", calories: 165, protein: 31, carbs: 0, fats: 3.6 },
  { name: "Brown Rice", calories: 112, protein: 2.6, carbs: 23, fats: 0.9 },
  { name: "Broccoli", calories: 34, protein: 2.8, carbs: 7, fats: 0.4 },
  { name: "Olive Oil", calories: 884, protein: 0, carbs: 0, fats: 100 },
  { name: "Onion", calories: 40, protein: 1.1, carbs: 9.3, fats: 0.1 },
  { name: "Garlic", calories: 149, protein: 6.4, carbs: 33, fats: 0.5 },
  { name: "Bell Pepper", calories: 31, protein: 1, carbs: 7, fats: 0.3 },
  { name: "Tomato", calories: 18, protein: 0.9, carbs: 3.9, fats: 0.2 },
  { name: "Pasta", calories: 131, protein: 5, carbs: 25, fats: 1.1 },
  { name: "Ground Beef", calories: 250, protein: 26, carbs: 0, fats: 15 }
]

foods.each do |food_attrs|
  Food.find_or_create_by(name: food_attrs[:name]) do |food|
    food.calories = food_attrs[:calories]
    food.protein = food_attrs[:protein]
    food.carbs = food_attrs[:carbs]
    food.fats = food_attrs[:fats]
  end
end

# Create a sample user if needed (for testing)
user = User.first || User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# Create sample recipes
recipes_data = [
  {
    name: "Healthy Chicken Stir Fry",
    description: "A nutritious and delicious chicken stir fry with vegetables",
    instructions: "1. Heat olive oil in a large pan\n2. Add diced onion and garlic, cook for 2 minutes\n3. Add chicken breast pieces, cook until golden\n4. Add bell peppers and broccoli, stir fry for 5 minutes\n5. Season with salt and pepper\n6. Serve hot",
    servings: 4,
    prep_time_minutes: 15,
    cook_time_minutes: 20,
    public: true,
    ingredients: [
      { food: "Chicken Breast", quantity: 500, unit: "grams" },
      { food: "Broccoli", quantity: 300, unit: "grams" },
      { food: "Bell Pepper", quantity: 200, unit: "grams" },
      { food: "Onion", quantity: 100, unit: "grams" },
      { food: "Garlic", quantity: 10, unit: "grams" },
      { food: "Olive Oil", quantity: 15, unit: "grams" }
    ]
  },
  {
    name: "Simple Pasta Marinara",
    description: "Classic pasta with homemade marinara sauce",
    instructions: "1. Cook pasta according to package directions\n2. Heat olive oil in a pan\n3. Add garlic and onion, cook until fragrant\n4. Add diced tomatoes and simmer for 15 minutes\n5. Season with salt and pepper\n6. Toss with cooked pasta",
    servings: 2,
    prep_time_minutes: 10,
    cook_time_minutes: 25,
    public: true,
    ingredients: [
      { food: "Pasta", quantity: 200, unit: "grams" },
      { food: "Tomato", quantity: 400, unit: "grams" },
      { food: "Onion", quantity: 50, unit: "grams" },
      { food: "Garlic", quantity: 8, unit: "grams" },
      { food: "Olive Oil", quantity: 10, unit: "grams" }
    ]
  },
  {
    name: "Beef and Rice Bowl",
    description: "Hearty beef and rice bowl perfect for post-workout meals",
    instructions: "1. Cook brown rice according to package directions\n2. Brown ground beef in a pan\n3. Add onions and cook until soft\n4. Season with salt and pepper\n5. Serve beef over rice",
    servings: 3,
    prep_time_minutes: 5,
    cook_time_minutes: 30,
    public: false,
    ingredients: [
      { food: "Ground Beef", quantity: 300, unit: "grams" },
      { food: "Brown Rice", quantity: 150, unit: "grams" },
      { food: "Onion", quantity: 75, unit: "grams" }
    ]
  }
]

recipes_data.each do |recipe_data|
  recipe = user.recipes.find_or_create_by(name: recipe_data[:name]) do |r|
    r.description = recipe_data[:description]
    r.instructions = recipe_data[:instructions]
    r.servings = recipe_data[:servings]
    r.prep_time_minutes = recipe_data[:prep_time_minutes]
    r.cook_time_minutes = recipe_data[:cook_time_minutes]
    r.public = recipe_data[:public]
  end

  # Add ingredients
  recipe_data[:ingredients].each_with_index do |ingredient_data, index|
    food = Food.find_by(name: ingredient_data[:food])
    next unless food

    recipe.recipe_ingredients.find_or_create_by(food: food) do |ri|
      ri.quantity = ingredient_data[:quantity]
      ri.unit = ingredient_data[:unit]
      ri.order_index = index
    end
  end
end

puts "Created #{Recipe.count} recipes with ingredients!"
puts "Foods available: #{Food.pluck(:name).join(', ')}"