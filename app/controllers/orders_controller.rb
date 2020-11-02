class OrdersController <ApplicationController

  def index
    # binding.pry
    @orders = Order.all
  end

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(order_params)
    order.user = current_user
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      # redirect_to "/orders/#{order.id}"
      flash[:success] = "The order was created"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])
    order.cancel_order
    flash[:success] = "Your order was cancelled"
    redirect_to profile_path
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
