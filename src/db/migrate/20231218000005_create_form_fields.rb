class CreateFormFields < ActiveRecord::Migration[7.1]
  def change
    create_table :form_fields do |t|
      t.references :document, null: false, foreign_key: true
      t.references :field_definition, foreign_key: true
      t.integer :field_type, null: false
      t.string :label, null: false
      t.text :value
      t.decimal :position_x, precision: 10, scale: 2, null: false
      t.decimal :position_y, precision: 10, scale: 2, null: false
      t.decimal :width, precision: 10, scale: 2
      t.decimal :height, precision: 10, scale: 2
      t.json :options
      t.boolean :required, default: false

      t.timestamps
    end

    add_index :form_fields, :field_type
  end
end 