class User < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :senders, dependent: :destroy

  def self.from_auth_hash(auth)
    where(uid: auth.uid)
      .first_or_initialize
      .tap do |user|
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.access_token = auth.credentials.token
        user.refresh_token = auth.credentials.refresh_token
        user.token_expires_at = Time.zone.at(auth.credentials.expires_at)
        user.save!
      end
  end

  def current_access_token
    refresh! if token_expires_at.past?
    access_token
  end

  # TODO: Consider raising an error if unable to refresh the token.
  def refresh!
    new_token = OAuth2::AccessToken.new(oauth_strategy.client, access_token, refresh_token: refresh_token).refresh!
    return unless new_token.present?

    update(
      access_token: new_token.token,
      refresh_token: new_token.refresh_token,
      token_expires_at: Time.zone.at(new_token.expires_at)
    )
  end

  def oauth_strategy
    OmniAuth::Strategies::GoogleOauth2.new(
      nil,
      Rails.application.credentials.google_client_id!,
      Rails.application.credentials.google_client_secret!
    )
  end
end
