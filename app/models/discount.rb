class Discount < ApplicationRecord
  validates_presence_of :name, :percentage, :threshold, :merchant_id

  belongs_to :merchant
  has_many :item_orders

  def invalid_percentage?
    percentage < 0 || percentage > 100
  end
end
