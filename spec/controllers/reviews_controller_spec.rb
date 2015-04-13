require "spec_helper"

describe ReviewsController do
  describe "POST create" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user)}
      let(:video) { Fabricate(:video)}
      before do
        session[:user_id] = user.id
      end
      it "expects a logged in user" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(session[:user_id]).not_to be(nil)
      end
      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end
        it "redirects to video show page" do
          expect(response).to redirect_to video_path(video)
        end
        it "creates a review" do
          expect(Review.count).to eq(1)
        end
        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end
        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(user)
        end
      end
      context "with invalid inputs" do
        before do
          post :create, review: {review: "", rating: "5"}, video_id: video.id
        end
        it "renders the video page" do
          expect(response).to render_template "videos/show"
        end
        it "sets the video instance variable" do
          expect(assigns(:video)).to eq(video)
        end
        it "sets the review instance variable" do
          expect(assigns(:review).class).to eq(Review)
        end
      end
    end
    context "with unauthenticated user" do
      before do
        video = Fabricate(:video)
        user = Fabricate(:user)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
      end
      it "expects session user_id to be nil" do
        expect(session[:user_id]).to be(nil)
      end
      it "redirects to sign_in path" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end