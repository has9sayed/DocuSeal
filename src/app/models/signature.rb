class Signature < ApplicationRecord
  belongs_to :user
  belongs_to :document
  has_one_attached :signature_image

  validates :status, presence: true
  validates :email, presence: true
  validates :name, presence: true

  enum status: {
    pending: 0,
    signed: 1,
    declined: 2,
    expired: 3
  }

  before_create :generate_signing_token

  def sign(signature_data)
    return false if signed?

    transaction do
      signature_image.attach(signature_data) if signature_data
      update(
        status: :signed,
        signed_at: Time.current
      )
      document.complete_signing if document.signatures.all?(&:signed?)
    end
  end

  private

  def generate_signing_token
    self.signing_token = SecureRandom.urlsafe_base64(32)
  end
end 