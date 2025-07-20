class FoodItemsController < ApplicationController
  before_action :set_food_item, only: %i[ show edit update destroy ]

  # GET /food_items or /food_items.json
  def index
    @food_items = FoodItem.all
  end

  # GET /food_items/1 or /food_items/1.json
  def show
  end

  # GET /food_items/new
  def new
    @meal = Meal.find(params[:meal_id])
    @food_item = FoodItem.new
    @date = Date.parse(params[:date])
  end

  # GET /food_items/1/edit
  def edit
  end

  # POST /food_items or /food_items.json
  def create
    @food_item = FoodItem.new(food_item_params)
    @food_item.food = Food.find(params[:food_item][:food_id]) if params[:food_item][:food_id].present?
    @food_item.meal = Meal.find(params[:meal_id])
    respond_to do |format|
      if @food_item.save
        if @food_item.food.nil? && !params[:food_item][:food_id].present?
          @food_item.food = Food.create!(food_item_params.except(:consumed_at))
          @food_item.save
        end
        format.html { redirect_to meals_path(date: params[:food_item][:consumed_at]), notice: "Food successfully logged!" }
        format.json { render :show, status: :created, location: @food_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @food_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /food_items/1 or /food_items/1.json
  def update
    respond_to do |format|
      if @food_item.update(food_item_params)
        format.html { redirect_to @food_item, notice: "Food successfully updated." }
        format.json { render :show, status: :ok, location: @food_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @food_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_items/1 or /food_items/1.json
  def destroy
    @food_item = FoodItem.find(params[:id])
    @meal = @food_item.meal
    @food_item.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to meals_path, status: :see_other, notice: "Food item was successfully deleted." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food_item
      @food_item = FoodItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def food_item_params
      params.expect(food_item: [ :name, :calories, :protein, :carbs, :fats, :meal_id, :consumed_at ])
    end
end
