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
    set_default_image
    if @item.save
      flash[:notice] = "Your new item has been saved!"
      redirect_to '/merchant/items'
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      set_default_image
      @item.save
      flash[:notice] = "The #{@item.name} has been updated."
      redirect_to '/merchant/items'
    # else
    end
    if params[:toggle] == 'true'
      toggle_activation
      redirect_to "/merchant/items"
    end
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

  def toggle_activation
    if @item.active?
      @item.update(active?: false)
      flash[:notice] = "The item is no longer for sale"
    else
      @item.update(active?: true)
      flash[:notice] = "The item is for sale"
    end
  end

  def set_default_image
    if @item.image.empty?
      @item.image = 'https://breakthrough.org/wp-content/uploads/2018/10/default-placeholder-image.png'
    end
  end
end
