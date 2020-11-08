class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order
  belongs_to :discount, optional: true

  def subtotal
    price * quantity
  end
end
