class Message < ApplicationRecord
  belongs_to :user
  enum status: %i[pending trapped crapped ignored]
end
