require 'rails_helper'

RSpec.describe "workout_plans/show", type: :view do
  before(:each) do
    assign(:workout_plan, WorkoutPlan.create!(
      name: "Name",
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
