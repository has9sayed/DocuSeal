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
    pdf_service = PdfGeneratorService.new(self)
    pdf_service.generate
  end

  def send_for_signature
    return false unless pdf_file.attached?
    
    update(status: :pending_signatures)
    Notification.notify_signature_request(signatures.last) if signatures.any?
    true
  rescue StandardError => e
    Rails.logger.error "Failed to send document for signature: #{e.message}"
    false
  end

  def complete_signing
    update(status: :completed)
  end
end 