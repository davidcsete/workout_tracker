class WorkoutPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout_plan, only: %i[ show edit update destroy ]

  # GET /workout_plans or /workout_plans.json
  def index
    @workout_plans = WorkoutPlan.all.order(Arel.sql("CASE WHEN user_id = #{current_user.id} THEN 0 ELSE 1 END")).uniq
  end

  # GET /workout_plans/1 or /workout_plans/1.json
  def show
  end

  # GET /workout_plans/new
  def new
    @workout_plan = current_user.workout_plans.new
  end

  # GET /workout_plans/1/edit
  def edit
  end

  # POST /workout_plans or /workout_plans.json
  def create
    @workout_plan = current_user.workout_plans.new(workout_plan_params)
    if @workout_plan.save
      respond_to do |format|
        format.html do
          redirect_to workout_plans_path, notice: "Workout plan created successfully"
        end

        format.turbo_stream do
          render turbo_stream: turbo_stream.redirect_to(workout_plans_path)
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workout_plans/1 or /workout_plans/1.json
  def update
    respond_to do |format|
      if @workout_plan.update(workout_plan_params)
        format.html { redirect_to @workout_plan, notice: "Workout plan was successfully updated." }
        format.json { render :show, status: :ok, location: @workout_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @workout_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workout_plans/1 or /workout_plans/1.json
  def destroy
    @workout_plan.destroy!

    respond_to do |format|
      format.html { redirect_to workout_plans_path, status: :see_other, notice: "Workout plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workout_plan
      @workout_plan = WorkoutPlan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def workout_plan_params
      params.expect(workout_plan: [ :name, :user_id ])
    end
end
