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
  
    @exercise_trackings = ExerciseTracking
                            .where(exercise: @exercise, user: current_user)
                            .where("created_at >= ?", Time.zone.now.beginning_of_day)
                            .order(created_at: :desc)
  end  

  # GET /exercise_trackings/1/edit
  def edit
  end

  # POST /exercise_trackings or /exercise_trackings.json
  def create
    @workout_plan = WorkoutPlan.find(params[:exercise_tracking][:workout_plan_id])
    @exercise = Exercise.find(params[:exercise_tracking][:exercise_id])
    @exercise_tracking = ExerciseTracking.new(exercise_tracking_params)
    @exercise_tracking.exercise = @exercise
    @exercise_tracking.user = current_user

    if @exercise_tracking.save
      # Load today's trackings
      
      @exercise_trackings = ExerciseTracking
                              .where(exercise: @exercise, user: current_user)
                              .where("created_at >= ?", Time.zone.now.beginning_of_day)
                              .order(created_at: :desc)
  
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
              locals: { exercise_trackings: @exercise.exercise_trackings.today_for_user(current_user) }
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
