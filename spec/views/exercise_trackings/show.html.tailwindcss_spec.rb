require 'rails_helper'

RSpec.describe "exercise_trackings/show", type: :view do
  before(:each) do
    assign(:exercise_tracking, ExerciseTracking.create!(
      user: nil,
      exercise: nil,
      reps: 2,
      weight: 3.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3.5/)
  end
end
