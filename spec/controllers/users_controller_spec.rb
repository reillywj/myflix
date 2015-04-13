require "spec_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of User
    end
  end
  describe "POST create" do
    context "with valid user" do
      before { post :create, user: Fabricate.attributes_for(:user)}
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of User
      end
      it "creates a valid user" do
        expect(User.all.count).to eq(1)
      end
      it "redirects to sign_in path" do
        response.should redirect_to sign_in_path
      end
    end

    context "without valid user" do
      before do
        post :create, user: {email: nil, password: "password", full_name: Faker::Name.name }
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of User
      end
      it "does not create a new user" do
        expect(User.all.count).to eq(0)
      end
      it "render the new template" do
        response.should render_template :new
      end
    end
  end
end