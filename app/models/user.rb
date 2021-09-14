class User < ApplicationRecord
  def self.from_auth_hash(auth)
    where(uid: auth.uid)
      .first_or_initialize
      .tap do |user|
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.save!
      end
  end
end
