class ProductsController < ApplicationController
  before_action :find_product, only: :show
  before_action :load_data, :paginate_products, only: %i(index show)

  def index
    respond_to :js, :html
  end

  def show
    @related_products = @product.category.products.limit Settings.per_page_four
  end

  private

  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t ".unknown_product"
    redirect_to root_path
  end

  def load_data
    @categories = Category.all
    @q = Product.ransack params[:q]
    @products = @q.result.by_category(params[:category_id]).includes :images
  end

  def paginate_products
    @products = @products.page(params[:page])
                         .per Settings.products.number_page
  end
end
