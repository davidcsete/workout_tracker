class Api::FoodsController < ApplicationController
  before_action :authenticate_user!

  def index
    query = params[:q]&.strip

    if query.present?
      foods = Food.where("name ILIKE ?", "%#{query}%")
                  .order(:name)
                  .limit(10)
    else
      foods = Food.order(:name).limit(10)
    end

    render json: foods.map { |food|
      {
        id: food.id,
        name: food.name,
        calories: food.calories,
        protein: food.protein,
        carbs: food.carbs,
        fats: food.fats
      }
    }
  end

  def create
    food = Food.new(food_params)

    if food.save
      render json: {
        id: food.id,
        name: food.name,
        calories: food.calories,
        protein: food.protein,
        carbs: food.carbs,
        fats: food.fats
      }, status: :created
    else
      render json: { errors: food.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :calories, :protein, :carbs, :fats)
  end
end
