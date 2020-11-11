class Discount < ApplicationRecord
  validates_presence_of :name, :percentage, :threshold, :merchant_id

  belongs_to :merchant

  def invalid_percentage?
    percentage == nil || percentage < 0 || percentage > 100
  end

  def invalid_threshold?
    threshold == nil || threshold < 0
  end

  def self.discount_exists?(id)
    Discount.where(id: id) != []
  end
end
