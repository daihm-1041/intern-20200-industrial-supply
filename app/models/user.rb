class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email address phone_number
    password password_confirmation).freeze

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
             length: {minimum: Settings.validate.user.min_length_password}

  has_secure_password

  before_save :downcase_email

  enum role: {user: 0, admin: 1}, _prefix: true

  private

  def downcase_email
    email.downcase!
  end
end
