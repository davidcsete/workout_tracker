class Api::ExerciseTrackingsController < Api::BaseController
  # before_action :set_exercise_tracking, only: %i[ show edit update destroy ]
  # respond_to :html, :turbo_stream


  # GET /exercise_trackings or /exercise_trackings.json
  def index
    render json: ExerciseTrackingsService.new(current_user.id).call
  end

  # GET /exercise_trackings/1 or /exercise_trackings/1.json
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
