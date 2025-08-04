class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit update destroy ]
  before_action :set_workout_plan, only: %i[ new create index edit update ]
  before_action :ensure_workout_plan_owner, only: %i[ edit update ], if: -> { @workout_plan.present? }

  # GET /exercises or /exercises.json
  def index
    @workout_plan_exercises = @workout_plan.workout_plan_exercises
  end

  # GET /exercises/1 or /exercises/1.json
  def show
  end

  # GET /exercises/new
  def new
    @exercise = Exercise.new
  end

  # GET /exercises/1/edit
  def edit
  end

  # POST /exercises or /exercises.json
  def create
    @exercise = Exercise.new(exercise_params)
    day_of_week = params[:day_of_the_week]

    # Validate day_of_the_week is present
    if day_of_week.blank?
      @exercise.errors.add(:base, "Day of the week must be selected")
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      if @exercise.save
        # Get the next order for this day
        next_order = @workout_plan.workout_plan_exercises
                                  .where(day_of_the_week: day_of_week)
                                  .maximum(:order).to_i + 1

        # Create the WorkoutPlanExercise with day and order
        WorkoutPlanExercise.create!(
          workout_plan: @workout_plan,
          exercise: @exercise,
          day_of_the_week: day_of_week,
          order: next_order
        )

        format.html { redirect_to workout_plan_exercises_path(@workout_plan), notice: "Exercise created successfully." }
        format.json { render :show, status: :created, location: @exercise }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercises/1 or /exercises/1.json
  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        # Update the day of the week if provided and we're in workout plan context
        if @workout_plan && params[:day_of_the_week].present?
          workout_plan_exercise = @workout_plan.workout_plan_exercises.find_by(exercise: @exercise)
          if workout_plan_exercise && workout_plan_exercise.day_of_the_week != params[:day_of_the_week]
            # Get the next order for the new day
            next_order = @workout_plan.workout_plan_exercises
                                      .where(day_of_the_week: params[:day_of_the_week])
                                      .maximum(:order).to_i + 1

            workout_plan_exercise.update!(
              day_of_the_week: params[:day_of_the_week],
              order: next_order
            )
          end
        end

        if @workout_plan
          format.html { redirect_to workout_plan_exercises_path(@workout_plan), notice: "Exercise was successfully updated." }
        else
          format.html { redirect_to @exercise, notice: "Exercise was successfully updated." }
        end
        format.json { render :show, status: :ok, location: @exercise }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1 or /exercises/1.json
  def destroy
    @exercise.destroy!

    respond_to do |format|
      format.html { redirect_to exercises_path, status: :see_other, notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def exercise_params
      params.expect(exercise: [ :name, :description ])
    end

    def set_workout_plan
      @workout_plan = WorkoutPlan.find(params[:workout_plan_id]) if params[:workout_plan_id]
    end

    def ensure_workout_plan_owner
      unless @workout_plan.user == current_user
        redirect_to workout_plan_exercises_path(@workout_plan), alert: "You can only edit exercises in your own workout plans."
      end
    end
end
