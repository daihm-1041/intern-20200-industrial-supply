class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email address phone_number
    password password_confirmation).freeze

  PERMIT_CREATE_ATTRIBUTES = %i(name email address phone_number
    password password_confirmation role).freeze

  attr_accessor :remember_token

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
             length: {minimum: Settings.validate.user.min_length_password},
             allow_nil: true

  has_secure_password

  before_save :downcase_email

  enum role: {user: 0, admin: 1}, _prefix: true

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
