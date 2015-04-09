require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated user" do
      before {session[:user_id] = Fabricate(:user).id}
      it "sets @video" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "renders the show template" do
        video = Fabricate(:video)
        get :show, id: video.id
        response.should render_template(:show)
      end
    end

    context "without authenticated user redirect user to sign_in path" do
      it "redirects user to root path" do
        video = Fabricate(:video)
        get :show, id: video.id
        response.should redirect_to sign_in_path
      end
    end
  end

  describe "POST search" do
    context "with authenticated user" do
      before {session[:user_id] = Fabricate(:user).id}
      it "sets the @results variable" do
        video = Fabricate(:video)
        post :search, search_term: video.title
        expect(assigns(:results)).to eq([video])
      end
      it "sets the @video instance variable if there is only one result" do
        video = Fabricate(:video)
        post :search, search_term: video.title
        expect(assigns(:video)).to eq(video)
      end
      it "renders the show template if there is only one result" do
        video = Fabricate(:video)
        post :search, search_term: video.title
        response.should render_template(:show)
      end
      it "otherwise renders the search template" do
        video1 = Fabricate(:video, title: "abc movie")
        video2 = Fabricate(:video, title: "An abc story")
        post :search, search_term: "abc"
        response.should render_template(:search)
      end
    end

    context "unauthenticated user is redirected to sign_in path" do
      it "redirects unauthenticated user to sign_in path" do
        video = Fabricate(:video)
        post :search, search_term: video.title
        response.should redirect_to sign_in_path
      end
    end
  end
end