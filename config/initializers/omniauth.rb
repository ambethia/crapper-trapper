Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.google_client_id!,
           Rails.application.credentials.google_client_secret!
end
OmniAuth.config.allowed_request_methods = %i[get]
