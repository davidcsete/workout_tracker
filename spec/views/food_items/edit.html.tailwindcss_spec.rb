require 'rails_helper'

RSpec.describe "food_items/edit", type: :view do
  let(:food_item) {
    FoodItem.create!(
      name: "MyString",
      calories: 1,
      protein: 1.5,
      carbs: 1.5,
      fats: 1.5,
      meal: nil
    )
  }

  before(:each) do
    assign(:food_item, food_item)
  end

  it "renders the edit food_item form" do
    render

    assert_select "form[action=?][method=?]", food_item_path(food_item), "post" do

      assert_select "input[name=?]", "food_item[name]"

      assert_select "input[name=?]", "food_item[calories]"

      assert_select "input[name=?]", "food_item[protein]"

      assert_select "input[name=?]", "food_item[carbs]"

      assert_select "input[name=?]", "food_item[fats]"

      assert_select "input[name=?]", "food_item[meal_id]"
    end
  end
end
