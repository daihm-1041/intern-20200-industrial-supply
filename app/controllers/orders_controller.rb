class OrdersController < ApplicationController
  before_action :get_cart, only: %i(new create)
  before_action :require_login, only: %i(new)

  load_and_authorize_resource

  def index; end

  def new
    @order = Order.new
    @order.order_details.build
  end

  def create
    @order = Order.new order_params
    if @order.save
      session.delete :cart
      OrderWorker.perform_async @order.id
      flash[:success] = t "orders.create.order_created_success"
      redirect_to orders_history_path @order
    else
      flash[:danger] = t "orders.create.order_create_failed"
      render :new
    end
  end

  def update; end

  private

  def require_login
    return if current_user

    flash[:info] = t ".login_to_continue"
    redirect_to new_user_session_path
  end

  def get_cart
    if session[:cart]
      @product_ids = session[:cart].map{|item| item["product_id"]}
    end
    @carts = Product.filter_by_ids @product_ids
    @total = session[:cart].map do |item|
      item["quantity"] * Product.find_by(id: item["product_id"].to_i).price
    end.sum
  end

  def order_params
    params.require(:order).permit Order::PERMIT_CREATE_ATTRIBUTES
  end
end
