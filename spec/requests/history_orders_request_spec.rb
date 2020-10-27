require "rails_helper"
require "spec_helper"

RSpec.describe OrdersHistoryController, type: :controller do

  let(:product){ FactoryBot.create :product }
  let(:user){ FactoryBot.create :user }
  let(:order){ FactoryBot.create :order, user: user }

  let(:order_detail) do
    FactoryBot.create :order_detail,
      order: order,
      product: product
  end

  before { sign_in user }

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "should render template index" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    context "when valid param" do
      before {get :show, params: {id: order.id}}

      it "render show template" do
        expect(response).to render_template :show
      end
    end

    context "when invalid param" do
      before { get :show, params: {id: -4} }

      it "should return error message" do
        expect(flash[:danger])
        .to eq I18n.t(".orders_history.show.unknown_order")
      end

      it "render root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
