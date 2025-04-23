class CreateWeekdays < ActiveRecord::Migration[8.0]
  def change
    create_table :weekdays do |t|
      t.string :name

      t.timestamps
    end
  end
end
