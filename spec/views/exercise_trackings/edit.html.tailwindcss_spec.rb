require 'rails_helper'

RSpec.describe "exercise_trackings/edit", type: :view do
  let(:exercise_tracking) {
    ExerciseTracking.create!(
      user: nil,
      exercise: nil,
      reps: 1,
      weight: 1.5
    )
  }

  before(:each) do
    assign(:exercise_tracking, exercise_tracking)
  end

  it "renders the edit exercise_tracking form" do
    render

    assert_select "form[action=?][method=?]", exercise_tracking_path(exercise_tracking), "post" do

      assert_select "input[name=?]", "exercise_tracking[user_id]"

      assert_select "input[name=?]", "exercise_tracking[exercise_id]"

      assert_select "input[name=?]", "exercise_tracking[reps]"

      assert_select "input[name=?]", "exercise_tracking[weight]"
    end
  end
end
