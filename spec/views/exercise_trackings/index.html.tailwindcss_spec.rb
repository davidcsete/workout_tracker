require 'rails_helper'

RSpec.describe "exercise_trackings/index", type: :view do
  before(:each) do
    assign(:exercise_trackings, [
      ExerciseTracking.create!(
        user: nil,
        exercise: nil,
        reps: 2,
        weight: 3.5
      ),
      ExerciseTracking.create!(
        user: nil,
        exercise: nil,
        reps: 2,
        weight: 3.5
      )
    ])
  end

  it "renders a list of exercise_trackings" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.5.to_s), count: 2
  end
end
