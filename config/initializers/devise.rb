Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'

  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 5..30
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.scoped_views = true
  config.lock_strategy = :failed_attempts
  config.maximum_attempts = 5
  config.unlock_keys = [:email]
  config.unlock_in = 5.minutes
  config.last_attempt_warning = true
  config.omniauth :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_SECRET"]
  config.omniauth :facebook, ENV["APP_ID"], ENV["APP_SECRET"]
end
