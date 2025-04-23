require 'rails_helper'

RSpec.describe "workout_plans/index", type: :view do
  before(:each) do
    assign(:workout_plans, [
      WorkoutPlan.create!(
        name: "Name",
        user: nil
      ),
      WorkoutPlan.create!(
        name: "Name",
        user: nil
      )
    ])
  end

  it "renders a list of workout_plans" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
