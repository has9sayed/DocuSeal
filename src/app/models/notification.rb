class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true
  validates :notification_type, presence: true

  enum notification_type: {
    document_shared: 0,
    signature_requested: 1,
    document_signed: 2,
    signature_declined: 3,
    document_completed: 4
  }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc).limit(10) }

  def mark_as_read!
    update(read_at: Time.current)
  end

  def self.notify_signature_request(signature)
    create(
      user: signature.document.user,
      notifiable: signature,
      notification_type: :signature_requested,
      message: "#{signature.name} has been requested to sign #{signature.document.title}"
    )
  end

  def self.notify_document_signed(signature)
    create(
      user: signature.document.user,
      notifiable: signature,
      notification_type: :document_signed,
      message: "#{signature.name} has signed #{signature.document.title}"
    )
  end

  def self.notify_signature_declined(signature)
    create(
      user: signature.document.user,
      notifiable: signature,
      notification_type: :signature_declined,
      message: "#{signature.name} has declined to sign #{signature.document.title}"
    )
  end

  def self.notify_document_completed(document)
    create(
      user: document.user,
      notifiable: document,
      notification_type: :document_completed,
      message: "All signatures have been collected for #{document.title}"
    )
  end
end 