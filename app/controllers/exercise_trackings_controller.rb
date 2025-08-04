class ExerciseTrackingsController < ApplicationController
  include ActionView::RecordIdentifier

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
    @workout_plan = WorkoutPlan.find_by(id: params[:workout_plan_id]) || @exercise.workout_plan_exercises.first&.workout_plan
    @date = @exercise_tracking.performed_at.to_date
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
          streams = [
            turbo_stream.replace(
              "exercise_#{@exercise.id}",
              partial: "exercises/exercise",
              locals: { exercise: @exercise, workout_plan: @workout_plan }
            ),
            turbo_stream.replace(
              "tracking_feed",
              partial: "exercise_trackings/feed",
              locals: { exercise_trackings: @exercise_trackings }
            ),
            turbo_stream.prepend(
              "success_notifications",
              partial: "shared/success_toast",
              locals: {
                message: "Set logged successfully!",
                details: "#{@exercise_tracking.reps} reps × #{@exercise_tracking.weight}kg",
                scroll_target: dom_id(@exercise_tracking)
              }
            )
          ]



          render turbo_stream: streams
        }
        format.html {
          redirect_to workout_plan_exercises_path(@workout_plan), notice: "Exercise tracked successfully!"
        }
      end
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @exercise_trackings = ExerciseTracking
                              .where(exercise: @exercise, user: current_user)
                              .where("performed_at >= ? AND performed_at < ?", @date.beginning_of_day, @date.end_of_day)
                              .order(performed_at: :desc)

      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            "exercise_tracking_form",
            partial: "exercise_trackings/form",
            locals: {
              exercise_tracking: @exercise_tracking,
              exercise: @exercise,
              date: @date
            }
          )
        }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_trackings/1 or /exercise_trackings/1.json
  def update
    @exercise = @exercise_tracking.exercise
    @workout_plan = WorkoutPlan.find_by(id: params[:workout_plan_id]) || @exercise.workout_plan_exercises.first&.workout_plan
    @date = @exercise_tracking.performed_at.to_date
    
    respond_to do |format|
      if @exercise_tracking.update(exercise_tracking_params)
        # Reload trackings for the current date
        @exercise_trackings = ExerciseTracking
                                .where(exercise: @exercise, user: current_user)
                                .where("performed_at >= ? AND performed_at < ?", @date.beginning_of_day, @date.end_of_day)
                                .order(performed_at: :desc)

        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(
              "tracking_feed",
              partial: "exercise_trackings/feed",
              locals: { exercise_trackings: @exercise_trackings }
            ),
            turbo_stream.prepend(
              "success_notifications",
              partial: "shared/success_toast",
              locals: {
                message: "Set updated successfully!",
                details: "#{@exercise_tracking.reps} reps × #{@exercise_tracking.weight}kg"
              }
            )
          ]
        }
        format.html { 
          if @workout_plan
            redirect_to new_workout_plan_exercise_exercise_tracking_path(@workout_plan, @exercise), 
                        notice: "Exercise tracking was successfully updated."
          else
            redirect_to @exercise_tracking, notice: "Exercise tracking was successfully updated."
          end
        }
        format.json { render :show, status: :ok, location: @exercise_tracking }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            "edit_form",
            partial: "exercise_trackings/edit_form",
            locals: { exercise_tracking: @exercise_tracking }
          )
        }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exercise_tracking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_trackings/1 or /exercise_trackings/1.json
  def destroy
    @exercise = @exercise_tracking.exercise
    @workout_plan = WorkoutPlan.find_by(id: params[:workout_plan_id]) || @exercise.workout_plan_exercises.first&.workout_plan
    @date = @exercise_tracking.performed_at.to_date
    
    @exercise_tracking.destroy!

    # Reload trackings for the current date
    @exercise_trackings = ExerciseTracking
                            .where(exercise: @exercise, user: current_user)
                            .where("performed_at >= ? AND performed_at < ?", @date.beginning_of_day, @date.end_of_day)
                            .order(performed_at: :desc)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace(
            "tracking_feed",
            partial: "exercise_trackings/feed",
            locals: { exercise_trackings: @exercise_trackings }
          ),
          turbo_stream.prepend(
            "success_notifications",
            partial: "shared/success_toast",
            locals: {
              message: "Set deleted successfully!",
              details: "Exercise tracking removed"
            }
          )
        ]
      }
      format.html { 
        if @workout_plan
          redirect_to new_workout_plan_exercise_exercise_tracking_path(@workout_plan, @exercise), 
                      status: :see_other, notice: "Exercise tracking was successfully deleted."
        else
          redirect_to exercise_trackings_path, status: :see_other, notice: "Exercise tracking was successfully deleted."
        end
      }
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
