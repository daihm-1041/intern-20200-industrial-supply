require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe ProductsController, type: :controller do

  let(:product) do
    FactoryBot.create :product
  end

  describe "GET #index" do
    before {get :index, xhr: true, params: {page: 1}}

    it "should render template index" do
      expect(response).to render_template :index
    end

     it "show status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    context "when valid param" do
      before {get :show, params: {id: product.id}}

      it "valid product" do
        expect(assigns(:related_products)).to eq [product]
      end

      it "render show template" do
        expect(response).to render_template :show
      end
    end

    context "when invalid param" do
      before { get :show, params: {id: -4} }

      it "should return error message" do
        expect(flash[:danger])
        .to eq I18n.t(".products.show.unknown_product")
      end

      it "render root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
