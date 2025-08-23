# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_23_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "diet_goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "daily_calories"
    t.float "protein_percentage"
    t.float "carb_percentage"
    t.float "fat_percentage"
    t.float "weight_change_per_week"
    t.boolean "is_custom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_diet_goals_on_user_id"
  end

  create_table "exercise_trackings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "reps"
    t.float "weight"
    t.datetime "performed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_exercise_trackings_on_exercise_id"
    t.index ["user_id"], name: "index_exercise_trackings_on_user_id"
  end

  create_table "exercise_weekdays", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "weekday_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_exercise_weekdays_on_exercise_id"
    t.index ["weekday_id"], name: "index_exercise_weekdays_on_weekday_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_items", force: :cascade do |t|
    t.string "name"
    t.integer "calories"
    t.float "protein"
    t.float "carbs"
    t.float "fats"
    t.bigint "meal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "grams"
    t.bigint "food_id"
    t.date "consumed_at"
    t.bigint "recipe_id"
    t.decimal "recipe_servings", precision: 8, scale: 2
    t.index ["food_id"], name: "index_food_items_on_food_id"
    t.index ["meal_id"], name: "index_food_items_on_meal_id"
    t.index ["recipe_id"], name: "index_food_items_on_recipe_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.float "calories"
    t.float "protein"
    t.float "carbs"
    t.float "fats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "goal_type", default: 0, null: false
    t.index ["goal_type"], name: "index_goals_on_goal_type"
  end

  create_table "lifestyles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meals", force: :cascade do |t|
    t.string "name"
    t.integer "meal_type"
    t.datetime "consumed_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "recipe_copies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "original_recipe_id", null: false
    t.bigint "copied_recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["copied_recipe_id"], name: "index_recipe_copies_on_copied_recipe_id"
    t.index ["original_recipe_id"], name: "index_recipe_copies_on_original_recipe_id"
    t.index ["user_id", "original_recipe_id"], name: "index_recipe_copies_on_user_id_and_original_recipe_id", unique: true
    t.index ["user_id"], name: "index_recipe_copies_on_user_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "food_id", null: false
    t.decimal "quantity", precision: 8, scale: 2, null: false
    t.string "unit", default: "grams"
    t.integer "order_index", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_recipe_ingredients_on_food_id"
    t.index ["recipe_id", "order_index"], name: "index_recipe_ingredients_on_recipe_id_and_order_index"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "instructions"
    t.integer "servings", default: 1
    t.integer "prep_time_minutes"
    t.integer "cook_time_minutes"
    t.bigint "user_id", null: false
    t.boolean "public", default: false
    t.decimal "total_calories", precision: 8, scale: 2
    t.decimal "total_protein", precision: 8, scale: 2
    t.decimal "total_carbs", precision: 8, scale: 2
    t.decimal "total_fats", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_recipes_on_name"
    t.index ["user_id", "public"], name: "index_recipes_on_user_id_and_public"
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "user_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "activity_date", null: false
    t.integer "page_views", default: 0
    t.integer "actions_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_date"], name: "index_user_activities_on_activity_date"
    t.index ["user_id", "activity_date"], name: "index_user_activities_on_user_id_and_activity_date", unique: true
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "user_details", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "age"
    t.float "height"
    t.float "bodyweight"
    t.bigint "goal_id", null: false
    t.bigint "lifestyle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_user_details_on_goal_id"
    t.index ["lifestyle_id"], name: "index_user_details_on_lifestyle_id"
    t.index ["user_id"], name: "index_user_details_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.string "gender"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weekdays", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workout_plan_exercises", force: :cascade do |t|
    t.bigint "workout_plan_id", null: false
    t.bigint "exercise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day_of_the_week"
    t.integer "order"
    t.index ["exercise_id"], name: "index_workout_plan_exercises_on_exercise_id"
    t.index ["workout_plan_id"], name: "index_workout_plan_exercises_on_workout_plan_id"
  end

  create_table "workout_plans", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workout_plans_on_user_id"
  end

  add_foreign_key "diet_goals", "users"
  add_foreign_key "exercise_trackings", "exercises"
  add_foreign_key "exercise_trackings", "users"
  add_foreign_key "exercise_weekdays", "exercises"
  add_foreign_key "exercise_weekdays", "weekdays"
  add_foreign_key "food_items", "foods"
  add_foreign_key "food_items", "meals"
  add_foreign_key "food_items", "recipes"
  add_foreign_key "meals", "users"
  add_foreign_key "recipe_copies", "recipes", column: "copied_recipe_id"
  add_foreign_key "recipe_copies", "recipes", column: "original_recipe_id"
  add_foreign_key "recipe_copies", "users"
  add_foreign_key "recipe_ingredients", "foods"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "user_activities", "users"
  add_foreign_key "user_details", "goals"
  add_foreign_key "user_details", "lifestyles"
  add_foreign_key "user_details", "users"
  add_foreign_key "workout_plan_exercises", "exercises"
  add_foreign_key "workout_plan_exercises", "workout_plans"
  add_foreign_key "workout_plans", "users"
end
