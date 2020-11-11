class RemoveDiscountsFromItemOrders < ActiveRecord::Migration[5.2]
  def change
    remove_reference :item_orders, :discount, foreign_key: true
  end
end
