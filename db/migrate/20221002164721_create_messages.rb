class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :chats, foreign_key: true
      t.integer :message_number
      t.text :messages, null: false
      t.timestamps
    end
    add_index :messages, [:message_number, :chats_id], unique: true

  end
end
