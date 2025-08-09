class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :workout_plans, dependent: :destroy
  has_many :exercise_trackings, dependent: :destroy
  has_one :user_detail, dependent: :destroy
  has_one :diet_goal, dependent: :destroy
  has_many :meals, dependent: :destroy

  accepts_nested_attributes_for :user_detail, allow_destroy: true

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 20 },
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores" }
end
