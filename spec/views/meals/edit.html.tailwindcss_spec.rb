require 'rails_helper'

RSpec.describe "meals/edit", type: :view do
  let(:meal) {
    Meal.create!(
      name: "MyString",
      meal_type: 1,
      user: nil
    )
  }

  before(:each) do
    assign(:meal, meal)
  end

  it "renders the edit meal form" do
    render

    assert_select "form[action=?][method=?]", meal_path(meal), "post" do

      assert_select "input[name=?]", "meal[name]"

      assert_select "input[name=?]", "meal[meal_type]"

      assert_select "input[name=?]", "meal[user_id]"
    end
  end
end
