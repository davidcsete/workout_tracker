class RecipesController < ApplicationController
  before_action :set_recipe, only: [ :show, :edit, :update, :destroy, :copy, :add_to_meal ]

  def index
    @my_recipes = current_user.recipes.includes(:recipe_ingredients, :foods)
    @public_recipes = Recipe.public_recipes.where.not(user: current_user).includes(:user, :recipe_ingredients, :foods)

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @my_recipes = @my_recipes.where("name ILIKE ?", search_term)
      @public_recipes = @public_recipes.where("name ILIKE ?", search_term)
    end
  end

  def show
    @recipe_ingredients = @recipe.recipe_ingredients.includes(:food).ordered
  end

  def new
    @recipe = current_user.recipes.build
    @recipe.recipe_ingredients.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      create_recipe_ingredients
      redirect_to @recipe, notice: "Recipe was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipe_ingredients = @recipe.recipe_ingredients.includes(:food).ordered
  end

  def update
    if @recipe.update(recipe_params)
      update_recipe_ingredients
      redirect_to @recipe, notice: "Recipe was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe was successfully deleted."
  end

  def copy
    unless @recipe.can_be_copied_by?(current_user)
      redirect_to recipes_path, alert: "Cannot copy this recipe."
      return
    end

    if @recipe.copied_by?(current_user)
      redirect_to recipes_path, notice: "You have already copied this recipe."
      return
    end

    copied_recipe = @recipe.dup
    copied_recipe.user = current_user
    copied_recipe.public = false
    copied_recipe.name = "#{@recipe.name} (Copy)"

    if copied_recipe.save
      # Copy ingredients
      @recipe.recipe_ingredients.each do |ingredient|
        copied_recipe.recipe_ingredients.create!(
          food: ingredient.food,
          quantity: ingredient.quantity,
          unit: ingredient.unit,
          order_index: ingredient.order_index
        )
      end

      # Create copy record
      RecipeCopy.create!(
        user: current_user,
        original_recipe: @recipe,
        copied_recipe: copied_recipe
      )

      redirect_to copied_recipe, notice: "Recipe copied successfully!"
    else
      redirect_to @recipe, alert: "Failed to copy recipe."
    end
  end

  def add_to_meal
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @meal_types = Meal.meal_types.keys
    @servings = params[:servings]&.to_f || 1.0
  end

  def create_meal_from_recipe
    recipe = Recipe.find(params[:recipe_id])
    date = Date.parse(params[:date])
    meal_type = params[:meal_type]
    servings = params[:servings].to_f

    # Find or create meal
    meal = current_user.meals.where(
      meal_type: meal_type,
      consumed_at: date.all_day
    ).first_or_create do |m|
      m.consumed_at = date
    end

    # Add recipe as food item
    food_item = meal.food_items.build(
      name: "#{recipe.name} (#{servings} serving#{'s' if servings != 1})",
      recipe: recipe,
      recipe_servings: servings,
      grams: (recipe.total_grams * servings).round,
      consumed_at: date
    )

    if food_item.save
      redirect_to meals_path(date: date), notice: "Recipe added to meal successfully!"
    else
      redirect_to add_to_meal_recipe_path(recipe, date: date), alert: "Failed to add recipe to meal."
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, :instructions, :servings, :prep_time_minutes, :cook_time_minutes, :public)
  end

  def create_recipe_ingredients
    return unless params[:recipe_ingredients].present?

    params[:recipe_ingredients].each_with_index do |ingredient_params, index|
      next if ingredient_params[:food_id].blank? || ingredient_params[:quantity].blank?

      @recipe.recipe_ingredients.create!(
        food_id: ingredient_params[:food_id],
        quantity: ingredient_params[:quantity],
        unit: ingredient_params[:unit] || "grams",
        order_index: index
      )
    end
  end

  def update_recipe_ingredients
    @recipe.recipe_ingredients.destroy_all
    create_recipe_ingredients
  end
end
