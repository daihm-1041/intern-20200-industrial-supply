class Admins::ProductsController < Admins::BaseController
  before_action :load_data, only: %i(new create)

  def new
    @product = Product.new
    @product.images.build
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t ".product_created_success"
      redirect_to admins_products_path
    else
      flash[:danger] = t ".product_create_failed"
      render :new
    end
  end

  def index
    @products = Product.page(params[:page]).per Settings.products.number_page
  end

  private

  def load_data
    @categories = Category.all
    @suppliers = Supplier.all
  end

  def product_params
    params.require(:product).permit Product::PERMIT_ATTRIBUTES
  end
end
