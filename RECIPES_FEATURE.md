# Recipes Feature Implementation

## Overview
The recipes feature allows users to create, manage, and share recipes using existing foods in the system. Users can copy public recipes from other users and easily add recipes to their daily meals.

## Key Features

### 1. Recipe Creation
- Create recipes using existing foods from the database
- Add multiple ingredients with quantities and units
- Set serving sizes, prep time, and cook time
- Add cooking instructions and descriptions
- Make recipes public for others to copy

### 2. Recipe Management
- View all your recipes and public recipes from other users
- Edit your own recipes
- Delete your own recipes
- Search recipes by name

### 3. Recipe Copying
- Copy public recipes from other users to your collection
- Copied recipes become private by default
- Track which recipes you've copied to prevent duplicates

### 4. Meal Integration
- Add recipes directly to your daily meals
- Specify number of servings when adding to meals
- Automatic nutrition calculation based on recipe ingredients
- Seamless integration with existing meal tracking

## Database Structure

### Tables Created
- `recipes` - Main recipe information
- `recipe_ingredients` - Junction table for recipe-food relationships
- `recipe_copies` - Tracks which users copied which recipes
- Added `recipe_id` and `recipe_servings` to existing `food_items` table

### Key Models
- `Recipe` - Main recipe model with nutrition calculations
- `RecipeIngredient` - Manages ingredients and quantities
- `RecipeCopy` - Tracks recipe copying relationships

## Navigation
- Added "Recipes" tab to the bottom navigation bar
- Accessible at `/recipes`

## Usage Flow

1. **Creating a Recipe:**
   - Navigate to Recipes → Create Recipe
   - Fill in recipe details (name, description, servings, etc.)
   - Add ingredients by selecting foods and specifying quantities
   - Add cooking instructions
   - Choose whether to make it public

2. **Copying a Recipe:**
   - Browse public recipes on the Recipes page
   - Click "Copy" on any public recipe you want to add to your collection
   - The copied recipe becomes private and editable

3. **Adding Recipe to Meal:**
   - From any recipe page, click "Add to Meal"
   - Select the date, meal type, and number of servings
   - Recipe is automatically added to your meal with calculated nutrition

## Technical Implementation

### Nutrition Calculation
- Recipes automatically calculate total nutrition from ingredients
- Per-serving nutrition is calculated by dividing totals by serving count
- When added to meals, nutrition scales based on servings consumed

### Search & Filtering
- Search recipes by name
- Separate views for "My Recipes" and "Public Recipes"
- Only shows copy option for recipes you haven't already copied

### Permissions
- Users can only edit/delete their own recipes
- Public recipes can be viewed and copied by anyone
- Private recipes are only visible to the owner

## Future Enhancements
- Recipe ratings and reviews
- Recipe categories/tags
- Photo uploads for recipes
- Recipe sharing via links
- Meal planning with recipes
- Shopping list generation from recipes
- Recipe scaling (adjust serving sizes)
- Import recipes from URLs
- Recipe collections/cookbooks