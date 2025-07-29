# Hotwire Native configuration
Rails.application.configure do
  # Configure Hotwire Native settings
  config.hotwire_native = ActiveSupport::OrderedOptions.new

  # Set the user agent for Hotwire Native requests
  config.hotwire_native.user_agent = "Hotwire Native"

  # Configure path patterns that should be handled by the native app
  config.hotwire_native.path_patterns = [
    /^\/$/,
    /^\/dashboard/,
    /^\/food_items/,
    /^\/meals/,
    /^\/exercises/,
    /^\/workout_plans/
  ]
end
