class Discount < ApplicationRecord
  validates_presence_of :name, :percentage, :threshold, :merchant_id

  belongs_to :merchant
  has_many :item_orders
end
