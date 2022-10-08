class Message < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name Rails.application.class.parent_name.underscore
  document_type self.name.downcase

  #define relations
  belongs_to :chat, foreign_key: :chats_id

  #validation
  validates :messages, presence: true
  validates :chats_id, presence: true
  validates :message_number,  uniqueness: {scope: :chats_id}

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :messages, type: 'string'
    end
  end

end
