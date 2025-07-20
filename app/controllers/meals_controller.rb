class MealsController < ApplicationController
  before_action :set_meal, only: %i[ show edit update destroy ]

  # GET /meals or /meals.json
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @meals = current_user.meals.where(consumed_at: @date.all_day).includes(:food_items).order(meal_type: :asc)

    respond_to do |format|
      format.html do
        if request.headers["Turbo-Frame"] == "daily_totals"
          render partial: "daily_totals", locals: { date: @date }, layout: false
        elsif request.headers["Turbo-Frame"] == "daily_meals"
          render partial: "daily_meals", locals: { meals: @meals }, layout: false
        else
          # Regular page load
          render :index
        end
      end
    end
  end

  # GET /meals/1 or /meals/1.json
  def show
  end

  # GET /meals/new
  def new
    @meal = Meal.new
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    # Set the consumed_at to the selected date
    @meal.consumed_at = @date
  end

  # GET /meals/1/edit
  def edit
  end

  # POST /meals or /meals.json
  def create
    # Use the passed date parameter from the form or fall back to current time
    consumed_date = meal_params[:date] ? Date.parse(meal_params[:date]) : Date.current
    @meal = Meal.new(meal_type: meal_params[:meal_type].to_i, user_id: current_user.id, consumed_at: consumed_date)
    respond_to do |format|
      if Meal.where(meal_type: meal_params[:meal_type].to_i, user_id: current_user.id, consumed_at: consumed_date.all_day).exists?
        redirect_to meals_path(date: consumed_date), notice: "Meal was already created." and return
      end
      if @meal.save
        format.html { redirect_to meals_path(date: consumed_date), notice: "Meal was successfully created." }
        format.json { render :show, status: :created, location: @meal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meals/1 or /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        format.html { redirect_to @meal, notice: "Meal was successfully updated." }
        format.json { render :show, status: :ok, location: @meal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meals/1 or /meals/1.json
  def destroy
    @meal.destroy!

    respond_to do |format|
      format.html { redirect_to meals_path, status: :see_other, notice: "Meal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = Meal.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def meal_params
      params.expect(meal: [ :name, :meal_type, :consumed_at, :user_id, :date ])
    end
end
