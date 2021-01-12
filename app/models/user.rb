class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :lockable, :validatable, :omniauthable,
         omniauth_providers: %i(facebook google_oauth2)
  PERMIT_ATTRIBUTES = %i(name email address phone_number
    password password_confirmation).freeze

  PERMIT_CREATE_ATTRIBUTES = %i(name email address phone_number
    password password_confirmation role).freeze

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates  :name, presence: true,
             length: {maximum: Settings.validate.user.max_length_name}
  validates  :email, presence: true,
             length: {maximum: Settings.validate.user.max_length_email},
             format: {with: Settings.validate.user.validate_email_regex},
             uniqueness: {case_sensitive: false}
  validates  :address, presence: true,
             length: {maximum: Settings.validate.user.max_length_address}
  validates  :phone_number, presence: true,
             length: {maximum: Settings.validate.user.max_length_phone_number,
                      minimum: Settings.validate.user.min_length_phone_number},
             format: {with: Settings.validate.user.validate_phone_number_regex},
             uniqueness: {case_sensitive: false}
  validates  :password, presence: true,
             length: {minimum: Settings.validate.user.min_length_password,
                      maximum: Settings.validate.user.max_length_password},
             allow_nil: true

  enum role: {user: 0, admin: 1}, _prefix: true

  scope :filter_by_role, (lambda do |r|
    where(role: r) if r.present?
  end)

  class << self
    def from_omniauth auth
      where(email: auth.info.email)
        .first_or_initialize do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.uid = auth.uid
        user.provider = auth.provider
        user.save validate: false
      end
    end
  end
end
