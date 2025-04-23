require 'rails_helper'

RSpec.describe "workout_plans/edit", type: :view do
  let(:workout_plan) {
    WorkoutPlan.create!(
      name: "MyString",
      user: nil
    )
  }

  before(:each) do
    assign(:workout_plan, workout_plan)
  end

  it "renders the edit workout_plan form" do
    render

    assert_select "form[action=?][method=?]", workout_plan_path(workout_plan), "post" do

      assert_select "input[name=?]", "workout_plan[name]"

      assert_select "input[name=?]", "workout_plan[user_id]"
    end
  end
end
