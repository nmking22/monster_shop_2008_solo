class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:merchant_id])
    redirect_to "/merchants/#{@merchant.id}"
  end
end
