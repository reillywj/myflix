require 'spec_helper'

describe VideosController do
  context "with authenticated user" do
    before { session[:user_id] = Fabricate(:user).id}

    describe "GET show" do
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

    describe "POST search" do
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
        category = Fabricate(:category)
        video1 = Video.create(title: "abc title", description: "short description", category: category)
        video2 = Video.create(title: "the documentary of the abcs", description: "other summary", category: category)
        post :search, search_term: "abc"
        response.should render_template(:search)
      end
    end
  end
end