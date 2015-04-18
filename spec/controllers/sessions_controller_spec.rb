require "spec_helper"

describe SessionsController do
  describe "GET new" do
    it "redirects to home_path if logged in" do
      set_current_user
      get :new
      response.should redirect_to home_path
    end

    it "renders the new session template if not logged in" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      it "sets the session user_id" do
        user = Fabricate(:user, password: "password")
        post :create, email: user.email, password: "password"
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home path" do
        user = Fabricate(:user, password: "password")
        post :create, email: user.email, password: "password"
        response.should redirect_to home_path
      end

      it "flashes a success message" do
        user = Fabricate(:user, password: "password")
        post :create, email: user.email, password: "password"
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      it "redirects to sign_in path with invalid email" do
        user = Fabricate(:user, email: "valid@email.com", password: "valid_password")
        post :create, email: "invalid@email.com", password: "valid_password"
        expect_redirect_to_sign_in_path
      end

      it "redirects to sign_in path with invalid password" do
        user = Fabricate(:user, password: "password")
        post :create, email: user.email, password: "invalid_password"
        expect_redirect_to_sign_in_path
      end

      it "flashes a danger message" do
        post :create, email: "some@email.com", password: "some_password"
        expect(flash[:danger]).not_to be_blank
      end
    end
  end
  
  describe "GET destroy" do
    before do
      set_current_user
      get :destroy
    end

    it "sets session user_id to nil" do
      expect(session[:user_id]).to eq(nil)
    end

    it "redirects to root path" do
      response.should redirect_to root_path
    end

    it "flashes a success message" do
      expect(flash[:success]).not_to be_blank
    end
  end
end