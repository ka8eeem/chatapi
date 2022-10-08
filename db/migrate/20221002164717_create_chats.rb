class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.references :applications, foreign_key: true
      t.string :chat_users # descriptive field
      t.integer :chat_number
      t.integer :messages_count, default: 0
      t.timestamps

    end
    add_index :chats, [:chat_number, :applications_id], unique: true
  end
end
