class User < ApplicationRecord

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true
  validates :password, confirmation: { case_sensitive: true }
  validates_presence_of :name, :address, :city, :state, :zip

  has_secure_password

end
