require "rails_helper"
require "spec_helper"

RSpec.describe Admins::UsersController, type: :controller do

  let(:admin_user) { FactoryBot.create :user, role: "admin" }
  let(:user){ FactoryBot.create :user, role: "user" }
  let(:params) { FactoryBot.attributes_for :user }

  before { sign_in admin_user }

  describe "GET #new" do
    before {get :new}

    it "should render template new" do
      expect(response).to render_template :new
    end
  end

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "should render template index" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    context "when valid param" do
      before {get :show, params: {id: user.id}}

      it "valid user" do
        expect(assigns(:user).id).to eq user.id
      end

      it "render show template" do
        expect(response).to render_template :show
      end
    end

    context "when invalid param" do
      before { get :show, params: {id: -4} }

      it "should return error message" do
        expect(flash[:danger])
        .to eq I18n.t(".admins.users.show.unknown_user")
      end

      it "shoudl redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #edit" do
    context "when valid param" do
      before {get :edit, params: {id: user.id}}

      it "valid user" do
        expect(assigns(:user).id).to eq user.id
      end

      it "render show template" do
        expect(response).to render_template :edit
      end
    end

    context "when invalid param" do
      before { get :edit, params: {id: -4} }

      it "should return error message" do
        expect(flash[:danger])
        .to eq I18n.t(".admins.users.edit.unknown_user")
      end

      it "shoudl redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    context "when valid param" do
      before { post :create, params: {user: params} }

      it "should redirect to admin_root_path" do
        expect(response).to redirect_to admins_users_path
      end

      it "should return success message" do
        expect(flash[:success])
        .to eq I18n.t(".admins.users.create.user_created_success")
      end
    end

    context "when invalid param" do
      before { post :create, params: {user: {name: ""}} }

      it "should render view new" do
        expect(response).to render_template :new
      end

      it "should return error message" do
        expect(flash[:danger]).to eq I18n.t(".admins.users.create.user_create_failed")
      end
    end
  end

  describe "PATCH #update" do
    context "when valid param" do
      before { patch :update, params: {id: user.id, user: params} }

      it "should update and redirect to admin_user_path" do
        expect(response).to redirect_to admins_user_path
      end

      it "should return success message" do
        expect(flash[:success]).to eq I18n.t(".admins.users.update.user_updated")
      end
    end

    context "when invalid param" do
      before { patch :update, params: {id: user.id, user: {name: ""}} }

      it "should render edit" do
        expect(response).to render_template :edit
      end

      it "should return error message" do
        expect(flash[:danger]).to eq I18n.t(".admins.users.update.user_update_fail")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when valid param" do
      before { delete :destroy, params: {id: user.id} }

      it "destroy user" do
        expect(assigns(:user).destroyed?).to eq true
      end

      it "should redirect to admins_users_path" do
        expect(response).to redirect_to admins_users_path
      end
    end

    context "when invalid param" do
      before { delete :destroy, params: {id: -4} }

      it "should return error message" do
        expect(flash[:danger]).to eq I18n.t(".admins.users.destroy.unknown_user")
      end
    end

    context "when delete fail" do
      before do
        allow_any_instance_of(User).to receive(:destroy).and_return false
        delete :destroy, params: {id: user.id}
      end

      it "should return fail message" do
        expect(flash[:danger]).to eq I18n.t(".admins.users.destroy.user_delete_fail")
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
