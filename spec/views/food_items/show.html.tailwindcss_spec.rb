require 'rails_helper'

RSpec.describe "food_items/show", type: :view do
  before(:each) do
    assign(:food_item, FoodItem.create!(
      name: "Name",
      calories: 2,
      protein: 3.5,
      carbs: 4.5,
      fats: 5.5,
      meal: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/4.5/)
    expect(rendered).to match(/5.5/)
    expect(rendered).to match(//)
  end
end
