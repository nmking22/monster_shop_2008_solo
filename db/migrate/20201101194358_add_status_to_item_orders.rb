class AddStatusToItemOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :item_orders, :status, :string, default: 'pending'
  end
end
