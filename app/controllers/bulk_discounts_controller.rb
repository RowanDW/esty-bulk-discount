class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    discount = BulkDiscount.new(discount_params)
    if discount.save
      redirect_to merchant_bulk_discounts_path(params[:merchant_id])
      flash[:success] = "Bulk discount created successfully"
    else
      redirect_to new_merchant_bulk_discount_path(params[:merchant_id])
      flash[:danger] = "Error: invalid discount, please try again"
    end
  end

  private

  def discount_params
     params.require(:bulk_discount).permit(:percentage, :quantity, :merchant_id)
  end
end
