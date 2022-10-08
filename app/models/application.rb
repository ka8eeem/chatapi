class Application < ApplicationRecord

  #define relations
  has_many :chats
  has_many :messages, through: :chats

  # validation
  validates :name, presence: true
  validates :token, presence: true
end
