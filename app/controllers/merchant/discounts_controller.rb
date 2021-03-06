class Merchant::DiscountsController < Merchant::BaseController
  def index
    user = User.find(current_user.id)
    @merchant = user.merchant
    @discounts = @merchant.discounts
  end

  def new
  end

  def create
    discount = Discount.new(discount_params)
    discount.merchant = current_user.merchant
    if discount.invalid_threshold?
      redirect_to '/merchant/discounts/new', notice: 'Minimum Items for Activation must be filled with an integer zero or greater.'
    elsif discount.invalid_percentage?
      redirect_to '/merchant/discounts/new', notice: 'Discount percentage must be filled with an integer or float between 0 and 100.'
    elsif !discount.save
      redirect_to '/merchant/discounts/new', notice: 'All fields must be filled in.'
    else
      redirect_to '/merchant/discounts'
    end
  end

  def show
    if Discount.discount_exists?(params[:id])
      @discount = Discount.find(params[:id])
    else
      redirect_to '/merchant/discounts', notice: 'Invalid URL. No discount exists with that ID.'
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    discount.assign_attributes(discount_params)
    if discount.invalid_threshold?
      redirect_to "/merchant/discounts/#{discount.id}/edit", notice: 'Minimum Items for Activation must be filled with an integer zero or greater.'
    elsif discount.invalid_percentage?
      redirect_to "/merchant/discounts/#{discount.id}/edit", notice: 'Discount percentage must be filled with an integer or float between 0 and 100.'
    elsif !discount.save
      redirect_to "/merchant/discounts/#{discount.id}/edit", notice: 'All fields must be filled in.'
    else
      redirect_to "/merchant/discounts/#{discount.id}"
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.permit(:name, :percentage, :threshold)
  end
end
