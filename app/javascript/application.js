// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "page_transitions"
import "@rails/ujs"
import "theme_handler"
// Rails.start() // <-- This initializes UJS to handle method: :delete etc.
import { application } from "controllers/application"
import StepsController from "controllers/steps_controller"
import WorkoutChartController from "controllers/workout_chart_controller"
import FoodSearchController from "controllers/food_search_controller"
import MealDateController from "controllers/meal_date_controller"
// import MacroChartController from "controllers/macro_chart_controller"
// import FlashController from "./controllers/flash_controller"
application.register("chart", WorkoutChartController)
application.register("steps", StepsController)
application.register("autocomplete", FoodSearchController)
application.register("meal_date", MealDateController)
// application.register("flash", FlashController)
// application.register("macro-chart", MacroChartController)

Turbo.session.drive = true
