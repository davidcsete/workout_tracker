class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :workout_plans, dependent: :destroy
  has_many :exercise_trackings, dependent: :destroy
  has_one :user_detail, dependent: :destroy
  has_many :meals, dependent: :destroy
end
