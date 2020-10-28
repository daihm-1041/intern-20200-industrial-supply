class OrdersHistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order, only: %i(show)

  load_and_authorize_resource Order, User

  def index
    @orders = current_user.orders
                          .includes(:order_details)
                          .page(params[:page]).per Settings.per_page
  end

  def show
    @product_items = @order.order_details.includes :product
  end

  private

  def find_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t ".unknown_order"
    redirect_to root_path
  end
end
