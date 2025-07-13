class UserDetail < ApplicationRecord
  belongs_to :user
  belongs_to :goal
  belongs_to :lifestyle
end
