class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [ :google_oauth2 ]

  has_many :workout_plans, dependent: :destroy
  has_many :exercise_trackings, dependent: :destroy
  has_one :user_detail, dependent: :destroy
  has_one :diet_goal, dependent: :destroy
  has_many :meals, dependent: :destroy

  accepts_nested_attributes_for :user_detail, allow_destroy: true

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 20 },
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores" }

  # Override Devise's password requirement for OAuth users
  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && provider.blank?
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = generate_username_from_email(auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  private

  def self.generate_username_from_email(email)
    base_username = email.split("@").first.gsub(/[^a-zA-Z0-9_]/, "_")
    username = base_username
    counter = 1

    while User.exists?(username: username)
      username = "#{base_username}_#{counter}"
      counter += 1
    end

    username
  end
end
