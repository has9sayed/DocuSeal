class Document < ApplicationRecord
  belongs_to :user
  belongs_to :template, optional: true
  has_many :signatures, dependent: :destroy
  has_many :form_fields, dependent: :destroy
  has_one_attached :pdf_file

  validates :title, presence: true
  validates :status, presence: true

  enum status: {
    draft: 0,
    pending_signatures: 1,
    completed: 2,
    expired: 3
  }

  def generate_pdf
    # PDF generation logic will be implemented here
  end

  def send_for_signature
    # Logic for sending document for signature
  end

  def complete_signing
    update(status: :completed)
  end
end 