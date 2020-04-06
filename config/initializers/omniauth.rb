Rails.application.config.middleware.use OmniAuth::Builder do
provider :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_CLIENT_SECRET'],
    client_options: {
      site: 'https://graph.facebook.com/v3.0',
      authorize_url: "https://www.facebook.com/v3.0/dialog/oauth"
    },
    token_params: { parse: :json },
    info_fields: 'name,email'
end