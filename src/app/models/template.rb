class Template < ApplicationRecord
  belongs_to :user
  has_many :documents
  has_many :field_definitions, dependent: :destroy
  has_one_attached :template_file

  validates :name, presence: true
  validates :description, presence: true

  def create_document(params = {})
    documents.create({
      user: self.user,
      title: params[:title] || self.name,
      status: :draft
    })
  end

  def duplicate
    new_template = self.dup
    new_template.name = "#{name} (Copy)"
    new_template.template_file.attach(template_file.blob) if template_file.attached?
    
    if new_template.save
      field_definitions.each do |field|
        new_template.field_definitions.create(field.attributes.except('id', 'created_at', 'updated_at'))
      end
    end
    
    new_template
  end
end 