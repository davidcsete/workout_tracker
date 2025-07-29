class Goal < ApplicationRecord
  has_many :user_details

  enum :goal_type, {
    lose_weight: 0,
    build_muscle: 1,
    lose_weight_and_build_muscle: 2,
    be_more_active: 3,
    gain_weight_and_build_muscle: 4,
    get_stronger: 5,
    get_stronger_and_build_more_muscle: 6
  }
end
