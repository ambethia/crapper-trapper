class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message_id, null: false, unique: true
      t.string :subject
      t.string :snippet
      t.string :sender_name
      t.string :sender_address
      t.string :sender_domain
      t.timestamp :sent_at
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
