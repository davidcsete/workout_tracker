require 'rails_helper'

RSpec.describe "meals/show", type: :view do
  before(:each) do
    assign(:meal, Meal.create!(
      name: "Name",
      meal_type: 2,
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
