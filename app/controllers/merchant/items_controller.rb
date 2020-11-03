class Merchant::ItemsController < Merchant::BaseController

  def index
    user = User.find(current_user.id)
    @merchant = user.merchant
    @items = @merchant.items
    # redirect_to '/items'
  end

  def update
    item = Item.find(params[:id])
    # US 47 might be impacted by the below, merchant editing items
    if item.active?
      item.update(active?: false)
      flash[:notice] = "The item is no longer for sale"
    else
      item.update(active?: true)
      flash[:notice] = "The item is for sale"
    end
    redirect_to "/merchant/items"
  end
end
