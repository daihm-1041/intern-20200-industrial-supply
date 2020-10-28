class CartsController < ApplicationController
  before_action :declare, :check_exist, :create_sessions_cart,
                :update_sessions_cart, only: :create

  skip_authorization_check

  def index
    return unless session[:cart]

    @carts = Product.filter_by_ids(load_product_ids)
                    .includes :images
    @categories = Category.all
    @total = session[:cart].map do |item|
      item["quantity"].to_i * Product.find_by(id: item["product_id"].to_i).price
    end.sum
  end

  def create
    render json: {
      sessions_length: session[:cart].length,
      total_item: @total_item,
      total: @total
    }
  end

  def update; end

  private

  def declare
    @exist = false
    @total_item = 0
    @total = 0
  end

  def check_exist
    session[:cart]&.each do |item|
      @exist = true if item["product_id"].to_i == params[:product_id].to_i
      product = Product.find_by id: item["product_id"]
      @total += product.price * item["quantity"]
    end
  end

  def create_sessions_cart
    return if @exist

    session[:cart] ||= []
    session[:cart].push(product_id: params[:product_id].to_i,
                        quantity: 1)
  end

  def update_sessions_cart
    return unless @exist

    session[:cart].map do |item|
      next unless item["product_id"].to_i == params[:product_id].to_i

      product = Product.find_by id: params[:product_id]
      case params[:option]
      when "dec"
        dec_quantity item, product
      when "inc"
        inc_quantity item, product
      when "del"
        del_quantity item, product
      end
    end
  end

  def dec_quantity item, product
    @total -= product.price
    if item["quantity"] > 1
      item["quantity"] -= 1
      @total_item = product.price * item["quantity"]
    else
      session[:cart].delete(item)
    end
  end

  def inc_quantity item, product
    item["quantity"] = item["quantity"] + 1
    @total_item = product.price * item["quantity"]
    @total += product.price
  end

  def del_quantity item, product
    @total_item = product.price * item["quantity"]
    @total -= @total_item
    session[:cart].delete(item)
  end

  def load_product_ids
    product_ids = []
    session[:cart].sort_by!{|k| k["product_id"].to_i}
    session[:cart].each{|item| product_ids << item["product_id"]}
    product_ids
  end

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end
end
