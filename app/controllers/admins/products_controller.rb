class Admins::ProductsController < Admins::BaseController
  before_action :load_data, except: %i(show destroy)
  before_action :find_product, except: %i(new create index)

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
    @products = @products.page(params[:page]).per Settings.products.number_page
  end

  def edit; end

  def update
    if @product.update product_params
      flash[:success] = t ".product_updated"
      redirect_to [:admins, @product]
    else
      flash[:danger] = t ".product_update_fail"
      render :edit
    end
  end

  def show; end

  def destroy
    if @product.destroy
      respond_to do |format|
        format.html{redirect_to admins_products_path}
        format.js
      end
    else
      flash[:danger] = t ".product_delete_fail"
      redirect_to admins_products_path
    end
  end

  private

  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t ".unknown_product"
    redirect_to admins_root_path
  end

  def load_data
    @categories = Category.all
    @suppliers = Supplier.all
    @products = Product.by_name(params[:keyword])
                       .by_supplier(params[:supplier_id])
                       .by_category(params[:category_id])
                       .by_from_price(params[:from_price])
                       .by_to_price(params[:to_price])
  end

  def product_params
    params.require(:product).permit Product::PERMIT_ATTRIBUTES
  end
end
