class ExerciseTrackingsController < ApplicationController
  before_action :set_exercise_tracking, only: %i[ show edit update destroy ]
  respond_to :html, :turbo_stream


  # GET /exercise_trackings or /exercise_trackings.json
  def index
    @exercise_trackings = ExerciseTracking.all.order(created_at: :desc)

    @exercise = Exercise.find(params[:exercise_id])
    @workout_plan = WorkoutPlan.find(params[:workout_plan_id])
  end

  # GET /exercise_trackings/1 or /exercise_trackings/1.json
  def show
  end

  # GET /exercise_trackings/new
  def new
    @workout_plan = WorkoutPlan.find(params[:workout_plan_id])
    @exercise = Exercise.find(params[:exercise_id])
    @exercise_tracking = ExerciseTracking.new

    @date = params[:date] ? Date.parse(params[:date]) : Date.current

    @exercise_trackings = ExerciseTracking
                            .where(exercise: @exercise, user: current_user)
                            .where("performed_at >= ? AND performed_at < ?", @date.beginning_of_day, @date.end_of_day)
                            .order(performed_at: :desc)
  end

  # GET /exercise_trackings/1/edit
  def edit
    @exercise_tracking = ExerciseTracking.find(params[:id])
    @exercise = @exercise_tracking.exercise
  end

  # POST /exercise_trackings or /exercise_trackings.json
  def create
    @workout_plan = WorkoutPlan.find(params[:exercise_tracking][:workout_plan_id])
    @exercise = Exercise.find(params[:exercise_tracking][:exercise_id])
    @exercise_tracking = ExerciseTracking.new(exercise_tracking_params)
    @exercise_tracking.exercise = @exercise
    @exercise_tracking.user = current_user
    # Set the performed_at date to the selected date
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @exercise_tracking.performed_at = @date

    if @exercise_tracking.save
      # Load trackings for the current date
      @exercise_trackings = ExerciseTracking
                              .where(exercise: @exercise, user: current_user)
                              .where("performed_at >= ? AND performed_at < ?", @date.beginning_of_day, @date.end_of_day)
                              .order(performed_at: :desc)

      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(
              "exercise_#{@exercise.id}",
              partial: "exercises/exercise",
              locals: { exercise: @exercise, workout_plan: @workout_plan }
            ),
            turbo_stream.replace(
              "tracking_feed",
              partial: "exercise_trackings/feed",
              locals: { exercise_trackings: @exercise_trackings }
            )
          ]
        }
        format.html {
          redirect_to workout_plan_exercises_path(@workout_plan), notice: "Exercise tracked successfully!"
        }
      end
    else
      render :new
    end
  end

  # PATCH/PUT /exercise_trackings/1 or /exercise_trackings/1.json
  def update
    respond_to do |format|
      if @exercise_tracking.update(exercise_tracking_params)
        format.html { redirect_to @exercise_tracking, notice: "Exercise tracking was successfully updated." }
        format.json { render :show, status: :ok, location: @exercise_tracking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exercise_tracking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_trackings/1 or /exercise_trackings/1.json
  def destroy
    @exercise_tracking.destroy!

    respond_to do |format|
      format.html { redirect_to exercise_trackings_path, status: :see_other, notice: "Exercise tracking was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_tracking
      @exercise_tracking = ExerciseTracking.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def exercise_tracking_params
      params.expect(exercise_tracking: [ :user_id, :exercise_id, :reps, :weight, :performed_at ])
    end
end
