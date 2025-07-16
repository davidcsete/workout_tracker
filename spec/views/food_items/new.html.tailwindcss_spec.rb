require 'rails_helper'

RSpec.describe "food_items/new", type: :view do
  before(:each) do
    assign(:food_item, FoodItem.new(
      name: "MyString",
      calories: 1,
      protein: 1.5,
      carbs: 1.5,
      fats: 1.5,
      meal: nil
    ))
  end

  it "renders new food_item form" do
    render

    assert_select "form[action=?][method=?]", food_items_path, "post" do

      assert_select "input[name=?]", "food_item[name]"

      assert_select "input[name=?]", "food_item[calories]"

      assert_select "input[name=?]", "food_item[protein]"

      assert_select "input[name=?]", "food_item[carbs]"

      assert_select "input[name=?]", "food_item[fats]"

      assert_select "input[name=?]", "food_item[meal_id]"
    end
  end
end
