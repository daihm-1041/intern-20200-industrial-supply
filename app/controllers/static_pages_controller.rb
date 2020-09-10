class StaticPagesController < ApplicationController
  def home
    @products = Product.includes(:images).page(params[:page]).per(Settings
      .products.number_page)
  end
end
