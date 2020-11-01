class Admin::MerchantsController < Admin::BaseController
  def index
    redirect_to '/merchants'
  end

  def show
    @merchant = Merchant.find(params[:id])
    redirect_to "/merchants/#{@merchant.id}"
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.enabled?
      @merchant.update(enabled?: false)
      @merchant.items.each do |item|
        item.update(active?: false)
      end
      redirect_to '/merchants', notice: "#{@merchant.name} has been disabled."
    else
      @merchant.update(enabled?: true)
      redirect_to '/merchants', notice: "#{@merchant.name}'s account has been enabled."
    end
  end
end
