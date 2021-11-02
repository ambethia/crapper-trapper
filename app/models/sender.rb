class Sender < ApplicationRecord
  belongs_to :user
  enum list: %i[blocked allowed]

  # broadcasts
end
