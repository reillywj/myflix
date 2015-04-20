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

      it("sets @user")                {expect(assigns(:user)).to be_instance_of User}
      it("creates a valid user")      {expect(User.all.count).to eq(1)}
      it("redirects to sign_in path") {expect_redirect_to_sign_in_path}
    end

    context "with invalid user" do
      before { post :create, user: {email: nil, password: "password", full_name: Faker::Name.name }}

      it("sets @user")                  {expect(assigns(:user)).to  be_instance_of User}
      it("does not create a new user")  {expect(User.all.count).to  eq(0)}
      it("render the new template")     {expect(response).to        render_template :new}
    end
  end
end