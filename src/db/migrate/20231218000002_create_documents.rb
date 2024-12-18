class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.references :template, foreign_key: true
      t.datetime :expires_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :documents, :status
  end
end 