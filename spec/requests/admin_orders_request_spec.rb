require "rails_helper"
require "spec_helper"

RSpec.describe Admins::OrdersController, type: :controller do

  let(:admin_user) { FactoryBot.create :user, role: "admin" }
  let(:user){ FactoryBot.create :user, role: "user" }
  let(:order){ FactoryBot.create :order }
  let(:params) { FactoryBot.attributes_for :order }

  before { sign_in admin_user }

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "should render template index" do
      expect(response).to render_template :index
    end
  end

  describe "GET #edit" do
    context "when valid param" do
      before {get :edit, params: {id: order.id}}

      it "valid order" do
        expect(assigns(:order).id).to eq order.id
      end

      it "render show template" do
        expect(response).to render_template :edit
      end
    end

    context "when invalid param" do
      before { get :edit, params: {id: -4} }

      it "should return error message" do
        expect(flash[:danger])
        .to eq I18n.t(".admins.orders.edit.unknown_order")
      end

      it "shoudl redirect admin_root_path" do
        expect(response).to redirect_to admins_root_path
      end
    end
  end

  describe "PATCH #update" do
    context "when valid param" do
      before { patch :update, params: {id: order.id, order: params} }

      it "should update and redirect to order" do
        expect(response).to redirect_to edit_admins_order_path(order)
      end

      it "should return success message" do
        expect(flash[:success]).to eq I18n.t(".admins.orders.update.order_updated")
      end
    end

    context "when invalid param" do
      before { patch :update, params: {id: order.id, order: {name_receiver: ""}} }

      it "should render edit" do
        expect(response).to render_template :edit
      end

      it "should return error message" do
        expect(flash[:danger]).to eq I18n.t(".admins.orders.update.order_update_fail")
      end
    end
  end
end
