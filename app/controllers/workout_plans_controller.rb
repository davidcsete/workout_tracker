class WorkoutPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout_plan, only: %i[ show edit update destroy ]
  before_action :set_any_workout_plan, only: %i[ duplicate ]

  # GET /workout_plans or /workout_plans.json
  def index
    @workout_plans = WorkoutPlan.includes(:user, :exercises, exercises: :exercise_trackings)
                                .order(Arel.sql("CASE WHEN user_id = #{current_user.id} THEN 0 ELSE 1 END"))
                                .uniq

    # Quick stats for dashboard
    @stats = {
      total_plans: current_user.workout_plans.count,
      total_exercises: current_user.workout_plans.joins(:exercises).count,
      workouts_this_week: current_user.workout_plans
                                     .joins(exercises: :exercise_trackings)
                                     .where(exercise_trackings: {
                                       performed_at: 1.week.ago.beginning_of_day..Time.current
                                     })
                                     .distinct
                                     .count
    }
  end

  # GET /workout_plans/1 or /workout_plans/1.json
  def show
    @is_owner = @workout_plan.user_id == current_user.id
  end

  # GET /workout_plans/new
  def new
    @workout_plan = current_user.workout_plans.new
  end

  # GET /workout_plans/1/edit
  def edit
    @workout_plan = current_user.workout_plans.includes(workout_plan_exercises: { exercise: :exercise_trackings }).find(params.expect(:id))
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
          redirect_to workout_plans_path, notice: "Workout plan created successfully"
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

  # POST /workout_plans/1/duplicate
  def duplicate
    original_plan = WorkoutPlan.find(params[:id])

    @workout_plan = current_user.workout_plans.build(
      name: "#{original_plan.name} (Copy)"
    )

    if @workout_plan.save
      # Copy exercises and their associations
      original_plan.workout_plan_exercises.each do |wpe|
        @workout_plan.workout_plan_exercises.create!(
          exercise: wpe.exercise,
          day_of_the_week: wpe.day_of_the_week,
          order: wpe.order
        )
      end

      respond_to do |format|
        format.html { redirect_to workout_plans_path, notice: "Workout plan copied successfully!" }
        format.turbo_stream {
          flash.now[:notice] = "Workout plan copied successfully!"
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to workout_plans_path, alert: "Failed to copy workout plan." }
        format.turbo_stream {
          flash.now[:alert] = "Failed to copy workout plan."
          render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash")
        }
      end
    end
  end

  # DELETE /workout_plans/1 or /workout_plans/1.json
  def destroy
    @workout_plan.destroy!

    respond_to do |format|
      format.html { redirect_to workout_plans_path, status: :see_other, notice: "Workout plan was successfully destroyed." }
      format.turbo_stream {
        flash.now[:notice] = "Workout plan was successfully destroyed."
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workout_plan
      @workout_plan = current_user.workout_plans.find(params.expect(:id))
    end

    def set_any_workout_plan
      @workout_plan = WorkoutPlan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def workout_plan_params
      params.expect(workout_plan: [ :name, :user_id ])
    end
end
