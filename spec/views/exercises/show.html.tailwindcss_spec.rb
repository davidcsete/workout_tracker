require 'rails_helper'

RSpec.describe "exercises/show", type: :view do
  before(:each) do
    assign(:exercise, Exercise.create!(
      name: "Name",
      description: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
