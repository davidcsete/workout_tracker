class WorkoutPlanExercisesController < ApplicationController
  before_action :set_workout_plan
  before_action :set_workout_plan_exercise, only: [ :destroy ]
  before_action :ensure_owner, only: [ :destroy ]

  def destroy
    @exercise = @workout_plan_exercise.exercise
    @workout_plan_exercise.destroy!

    respond_to do |format|
      format.html { redirect_to workout_plan_exercises_path(@workout_plan), notice: "Exercise removed from workout plan." }
      format.turbo_stream
      format.json { head :no_content }
    end
  end

  private

  def set_workout_plan
    @workout_plan = WorkoutPlan.find(params[:workout_plan_id])
  end

  def set_workout_plan_exercise
    @workout_plan_exercise = @workout_plan.workout_plan_exercises.find(params[:id])
  end

  def ensure_owner
    unless @workout_plan.user == current_user
      redirect_to workout_plan_exercises_path(@workout_plan), alert: "You can only remove exercises from your own workout plans."
    end
  end
end
