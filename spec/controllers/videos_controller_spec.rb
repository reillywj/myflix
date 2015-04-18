require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated user" do
      let(:video) {Fabricate :video}

      before do
        set_current_user
        get :show, id: video.id
      end

      it("sets @video")               {expect(assigns(:video)).to eq(video)}
      it("sets @review")              {expect(assigns(:review).class).to eq(Review)}
      it("renders the show template") {expect(response).to render_template(:show)}
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: Fabricate(:video).id }
    end
  end

  describe "POST search" do
    context "with authenticated user" do
      let(:video) {Fabricate :video}

      before do
        set_current_user
        post :search, search_term: video.title
      end

      it "sets the @results variable" do
        expect(assigns(:results)).to eq([video])
      end

      it "sets the @video instance variable if there is only one result" do
        expect(assigns(:video)).to eq(video)
      end

      it "renders the show template if there is only one result" do
        expect(response).to render_template(:show)
      end

      it "otherwise renders the search template" do
        video1 = Fabricate(:video, title: "abc movie")
        video2 = Fabricate(:video, title: "An abc story")
        post :search, search_term: "abc"
        expect(response).to render_template :search
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :search, search_term: Fabricate(:video).title }
    end
  end
end