Rails.application.configure do
  config.google_sign_in.client_id     = Rails.application.credentials.google_sign_in_client_id
  config.google_sign_in.client_secret = Rails.application.credentials.google_sign_in_client_secret
end