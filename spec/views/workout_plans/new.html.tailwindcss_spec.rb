require 'rails_helper'

RSpec.describe "workout_plans/new", type: :view do
  before(:each) do
    assign(:workout_plan, WorkoutPlan.new(
      name: "MyString",
      user: nil
    ))
  end

  it "renders new workout_plan form" do
    render

    assert_select "form[action=?][method=?]", workout_plans_path, "post" do

      assert_select "input[name=?]", "workout_plan[name]"

      assert_select "input[name=?]", "workout_plan[user_id]"
    end
  end
end
