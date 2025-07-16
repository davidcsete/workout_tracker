require 'rails_helper'

RSpec.describe "meals/new", type: :view do
  before(:each) do
    assign(:meal, Meal.new(
      name: "MyString",
      meal_type: 1,
      user: nil
    ))
  end

  it "renders new meal form" do
    render

    assert_select "form[action=?][method=?]", meals_path, "post" do

      assert_select "input[name=?]", "meal[name]"

      assert_select "input[name=?]", "meal[meal_type]"

      assert_select "input[name=?]", "meal[user_id]"
    end
  end
end
