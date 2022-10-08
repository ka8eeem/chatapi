class Chat < ApplicationRecord

  # define relations
  belongs_to :application, foreign_key: :applications_id
  has_many :messages

  #validation
  validates :applications_id, presence: true
  validates :chat_number,  uniqueness: {scope: :applications_id}

end
