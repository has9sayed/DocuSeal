class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.integer :notification_type, null: false
      t.text :message, null: false
      t.datetime :read_at
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :notifications, :notification_type
    add_index :notifications, :read_at
  end
end 