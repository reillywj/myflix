require "spec_helper"

describe QueueItemsController do
  describe "GET index" do
    context "with authenticated user" do
      let(:user) {Fabricate :user}
      let(:queue_item1) { Fabricate(:queue_item, user: user)}
      let(:queue_item2) { Fabricate(:queue_item, user: user)}
      before do
        session[:user_id] = user.id
      end
      it "assigns queue_items" do
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1,queue_item2])
      end
      it "shows index page" do
        get :index
        expect(response).to render_template :index
      end
    end
    context "with unauthenticated user" do
      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST create" do
    let(:video) {Fabricate :video} 
    context "with authenticated user" do
      let(:user) {Fabricate :user}
      before do
        session[:user_id] = user.id
        post :create, video_id: video.id
      end
      it "redirects to /my_queue page" do
        expect(response).to redirect_to my_queue_path
      end
      it "creates a queue_item" do
        expect(QueueItem.count).to eq(1)
      end
      it "creates a queue_item associated with the video" do
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates a queue_item associated with the signed in user" do
        expect(QueueItem.first.user).to eq(user)
      end
      it "puts the first video in the queue in position 1" do
        expect(QueueItem.first.video).to eq(video)
        expect(QueueItem.first.position).to eq(1)
      end
      it "puts the second video in the queue in position 2" do
        video2 = Fabricate(:video)
        post :create, video_id: video2.id #note: first video was already added in the before statement
        expect(QueueItem.last.video).to eq(video2)
        expect(QueueItem.last.position).to eq(2)
      end
      it "does not add the video to the queue if the video is already in the queue" do
        post :create, video_id: video.id #note: video was already added in the before statement
        expect(QueueItem.where(user: user).count).to eq(1)
      end
    end
    context "with unauthenticated user" do
      it "redirects to sign_in page" do
        post :create, video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE destroy" do
    let(:user) {Fabricate :user}
    it "redirects to /my_queue" do
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    it "removes queue item from the queue" do
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.all.count).to eq(0)
    end
    it "updates the queue positions of remains queue_items" do
      session[:user_id] = user.id
      queue_item_to_delete = Fabricate(:queue_item, user: user, position: 1)
      Fabricate(:queue_item, user: user, position: 2)
      Fabricate(:queue_item, user: user, position: 3)
      delete :destroy, id: queue_item_to_delete.id
      expect(user.queue_items).not_to include(queue_item_to_delete)
      expect(user.queue_items.first.position).to eq(1)
      expect(user.queue_items.last.position).to eq(2)
    end
    it "does not delete item if current_user does not own item" do
      another_user = Fabricate(:user)
      session[:user_id] = user.id
      anothers_queue_item = Fabricate(:queue_item, user: another_user, position: 1)
      delete :destroy, id: anothers_queue_item.id
      expect(QueueItem.all.count).to eq(1)
      expect(flash[:danger]).to eq("You can't do that.")
    end
    it "redirects to sign in page for unauthenticated users" do
      queue_item = Fabricate(:queue_item, user: user, position: 1)
      delete :destroy, id: queue_item.id
      expect(QueueItem.all.count).to eq(1)
      expect(response).to redirect_to sign_in_path
    end
  end
end