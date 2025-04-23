require 'rails_helper'

RSpec.describe "exercise_trackings/new", type: :view do
  before(:each) do
    assign(:exercise_tracking, ExerciseTracking.new(
      user: nil,
      exercise: nil,
      reps: 1,
      weight: 1.5
    ))
  end

  it "renders new exercise_tracking form" do
    render

    assert_select "form[action=?][method=?]", exercise_trackings_path, "post" do

      assert_select "input[name=?]", "exercise_tracking[user_id]"

      assert_select "input[name=?]", "exercise_tracking[exercise_id]"

      assert_select "input[name=?]", "exercise_tracking[reps]"

      assert_select "input[name=?]", "exercise_tracking[weight]"
    end
  end
end
