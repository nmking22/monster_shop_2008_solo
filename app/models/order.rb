class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity_of_items
    item_orders.sum(:quantity)
  end

  def cancel_order
    self.update(status: 'cancelled')
    item_orders.each do |order|
      if order.status == 'fulfilled'
       order.item.inventory += order.quantity
     end   #we need to test to make sure this is this doing the thing
       order.status = 'unfulfilled'
     end
  end

  def order_fulfilled
    if item_orders.all?{|order| order.status == 'fulfilled'}
      self.update(status: 'packaged')
    end
  end

end
