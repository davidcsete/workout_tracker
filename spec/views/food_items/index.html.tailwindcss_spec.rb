require 'rails_helper'

RSpec.describe "food_items/index", type: :view do
  before(:each) do
    assign(:food_items, [
      FoodItem.create!(
        name: "Name",
        calories: 2,
        protein: 3.5,
        carbs: 4.5,
        fats: 5.5,
        meal: nil
      ),
      FoodItem.create!(
        name: "Name",
        calories: 2,
        protein: 3.5,
        carbs: 4.5,
        fats: 5.5,
        meal: nil
      )
    ])
  end

  it "renders a list of food_items" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(5.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
