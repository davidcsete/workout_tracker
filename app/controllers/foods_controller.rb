# app/controllers/foods_controller.rb
class FoodsController < ApplicationController
  def search
    @foods = if params[:q].present?
      Food.where("name ILIKE ?", "%#{params[:q]}%")
          .order(:name)
          .limit(10)
    else
      []
    end

    render partial: "search_results"
  end
end
