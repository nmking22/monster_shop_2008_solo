class Merchant::ItemsController < Merchant::BaseController

  def index
    user = User.find(current_user.id)
    @merchant = user.merchant
    @items = @merchant.items
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.merchant = current_user.merchant
    if @item.image.empty?
      @item.image = 'https://breakthrough.org/wp-content/uploads/2018/10/default-placeholder-image.png'
    end
    if @item.save
      flash[:notice] = "Your new item has been saved!"
      redirect_to '/merchant/items'
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
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

  def destroy
    item = Item.find(params[:id])
    item.destroy!
    flash[:notice] = "The item is now deleted"
    redirect_to "/merchant/items"
  end

  private
  def item_params
    params.permit(:name, :description, :image, :price, :inventory)
  end
end
