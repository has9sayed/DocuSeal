class FormField < ApplicationRecord
  belongs_to :document
  belongs_to :field_definition, optional: true

  validates :field_type, presence: true
  validates :label, presence: true
  validates :position_x, presence: true
  validates :position_y, presence: true

  enum field_type: {
    text: 0,
    signature: 1,
    date: 2,
    checkbox: 3,
    dropdown: 4
  }

  def render_field
    case field_type.to_sym
    when :text
      # Render text input field
    when :signature
      # Render signature pad
    when :date
      # Render date picker
    when :checkbox
      # Render checkbox
    when :dropdown
      # Render dropdown with options
    end
  end
end 