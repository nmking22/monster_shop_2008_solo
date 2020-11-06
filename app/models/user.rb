class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true, presence: true
  validates :password, confirmation: { case_sensitive: true }
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :merchant, optional: true

  enum role: [:default_user, :merchant_user, :admin_user]

  has_many :orders

  def duplicate_email?
    User.pluck(:email).include?(email)
  end
end
