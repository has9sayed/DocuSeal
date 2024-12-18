class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :documents
  has_many :templates
  has_many :signatures
  has_many :notifications, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def unread_notifications_count
    notifications.unread.count
  end
end 