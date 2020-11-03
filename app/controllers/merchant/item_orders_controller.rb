class Merchant::ItemOrdersController < Merchant::BaseController

  def update
    item_order = ItemOrder.find(params[:id])
    quantity = item_order.quantity
    inventory = item_order.item.inventory
    total = inventory - quantity
      item_order.item.update(inventory: total)
      item_order.update(status: 'fulfilled')
      flash[:success] = "#{item_order.item.name} has been fulfilled"
    redirect_to "/merchant/orders/#{item_order.order_id}"
  end

end
