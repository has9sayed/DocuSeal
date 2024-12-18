class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.boolean :is_public, default: false
      t.integer :documents_count, default: 0

      t.timestamps
    end

    add_index :templates, :name
    add_index :templates, :is_public
  end
end 