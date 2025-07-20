class AddConsumedAtToFoodItems < ActiveRecord::Migration[8.0]
  def change
    add_column :food_items, :consumed_at, :date
  end
end
