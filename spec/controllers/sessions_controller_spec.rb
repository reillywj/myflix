require "spec_helper"

describe SessionsController do
  describe "GET new" do
    it "redirects to home_path if logged in" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "renders the new session template if not logged in" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      let(:user) {Fabricate :user, password: "password"}

      before {post :create, email: user.email, password: "password"}

      it("sets the session user_id") {expect(session[:user_id]).to eq(user.id)}
      it("redirects to home path") {response.should redirect_to home_path}
      it("flashes a success message") {expect(flash[:success]).not_to be_blank}
    end

    context "with invalid credentials" do
      let(:user) {Fabricate :user, email: "valid@email.com", password: "valid_password"}

      it "redirects to sign_in path with invalid email" do
        post :create, email: "invalid@email.com", password: "valid_password"
        expect_redirect_to_sign_in_path
      end

      it "redirects to sign_in path with invalid password" do
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

    it("sets session user_id to nil") {expect(session[:user_id]).to eq(nil)}
    it("redirects to root path") {expect(response).to redirect_to root_path}
    it("flashes a success message") {expect(flash[:success]).not_to be_blank}
  end
end