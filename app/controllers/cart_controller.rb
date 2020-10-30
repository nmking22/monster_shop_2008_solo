class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
    if current_admin_user?
      render file: "/public/404"
    end
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment
    item = Item.find(params[:item_id])
    if cart.items[item] < item.inventory
      cart.add_item(item.id.to_s)
    else
      flash[:error] = "Cannot add item"
    end
    redirect_to '/cart'
  end

  def decrement
    item = Item.find(params[:item_id])
    cart.decrement_item(item)
    redirect_to '/cart'
  end

end
