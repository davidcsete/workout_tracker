class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit update destroy ]
  before_action :set_workout_plan, only: %i[ new create index ]

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

    respond_to do |format|
      if @exercise.save
        WorkoutPlanExercise.create!(workout_plan: @workout_plan, exercise: @exercise)
        format.html { redirect_to edit_workout_plan_path(@workout_plan), notice: "Exercise created successfully." }
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
        format.html { redirect_to @exercise, notice: "Exercise was successfully updated." }
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
      @workout_plan = WorkoutPlan.find(params[:workout_plan_id])
    end
end
