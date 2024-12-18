class CreateSignatures < ActiveRecord::Migration[7.1]
  def change
    create_table :signatures do |t|
      t.references :user, null: false, foreign_key: true
      t.references :document, null: false, foreign_key: true
      t.string :email, null: false
      t.string :name, null: false
      t.integer :status, default: 0, null: false
      t.string :signing_token
      t.datetime :signed_at
      t.datetime :expires_at
      t.text :decline_reason

      t.timestamps
    end

    add_index :signatures, :email
    add_index :signatures, :status
    add_index :signatures, :signing_token, unique: true
  end
end 