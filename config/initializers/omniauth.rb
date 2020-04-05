Rails.application.config.middleware.use OmniAuth::Builder do
provider :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_CLIENT_SECRET'], scope: 'email'
end