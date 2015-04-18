require "spec_helper"

describe QueueItemsController do
  describe "GET index" do
    context "with authenticated user" do
      before { set_current_user }

      let(:queue_item1) { Fabricate :queue_item, user: get_current_user}
      let(:queue_item2) { Fabricate :queue_item, user: get_current_user}

      it "assigns queue_items" do
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end

      it "shows index page" do
        get :index
        expect(response).to render_template :index
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:video) {Fabricate :video} 

    context "with authenticated user" do
      before do
        set_current_user
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
        expect(QueueItem.first.user).to eq(get_current_user)
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
        expect(QueueItem.where(user: get_current_user).count).to eq(1)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, video_id: video.id }
    end
  end

  describe "DELETE destroy" do
    context "with authenticated user" do
      before { set_current_user }

      let(:queue_item_to_delete) {Fabricate :queue_item, user: get_current_user, position: 1}

      it "redirects to /my_queue" do
        delete :destroy, id: queue_item_to_delete.id
        expect(response).to redirect_to my_queue_path
      end

      it "removes queue item from the queue" do
        delete :destroy, id: queue_item_to_delete.id
        expect(QueueItem.all.count).to eq(0)
      end

      it "updates the queue positions of remains queue_items" do
        Fabricate(:queue_item, user: get_current_user, position: 2)
        Fabricate(:queue_item, user: get_current_user, position: 3)

        delete :destroy, id: queue_item_to_delete.id
        expect(get_current_user.queue_items).not_to include(queue_item_to_delete)
        expect(get_current_user.queue_items.map(&:position)).to eq([1,2])
      end

      it "does not delete item if current_user does not own item" do
        another_users_queue_item = Fabricate(:queue_item, user: Fabricate(:user), position: 1)
        delete :destroy, id: another_users_queue_item.id
        expect(QueueItem.all.count).to eq(1)
      end

      it "flashes danger if current_user does not own item" do
        another_users_queue_item = Fabricate(:queue_item, user: Fabricate(:user), position: 1)
        delete :destroy, id: another_users_queue_item.id
        expect(flash[:danger]).to eq("You can't do that.")
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) do
        queue_item = Fabricate(:queue_item, position: 1)
        delete :destroy, id: queue_item.id
        expect(QueueItem.all.count).to eq(1)
      end
    end
  end

  describe "POST update_queue" do
    let(:alice) {Fabricate(:user)}

    context "with valid inputs" do
      before { set_current_user }
      let(:queue_item1) {Fabricate(:queue_item, user: get_current_user, position: 1)}
      let(:queue_item2) {Fabricate(:queue_item, user: get_current_user, position: 2)}

      it "redirects to my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue_items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        first_queue_item = QueueItem.first
        expect(get_current_user.queue_items.map(&:id)).to eq([queue_item2.id, queue_item1.id])
      end

      it "normalizes position numbers 1 through n" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 5}, {id: queue_item2.id, position: 2}]
        expect(get_current_user.queue_items.map(&:id)).to eq([queue_item2.id, queue_item1.id])
        expect(get_current_user.queue_items.map(&:position)).to eq([1,2])
      end

      context "of updating a review rating" do
        it "adds a review to the queue_item" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 1, rating: 5}]
          expect(get_current_user.queue_items.first.video.reviews.first.rating).to eq(5)
        end
      end
    end

    context "with invalid inputs" do
      before { set_current_user }
      let(:queue_item1) {Fabricate :queue_item, user: get_current_user, position: 1}
      let(:queue_item2) {Fabricate :queue_item, user: get_current_user, position: 2}

      it "redirects to my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1.5}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets flash[:danger] message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1.5}, {id: queue_item2.id, position: 2}]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue_items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.5}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) {post :update_queue, queue_items: [{id: 1, position: 3}]}
    end

    context "with queue_item that does not belong to current user" do
      it "does not change the queue_items" do
        bob = Fabricate(:user)
        set_current_user
        queue_item1 = Fabricate(:queue_item, user: get_current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: get_current_user, position: 2)
        queue_item_bob = Fabricate(:queue_item, user: bob, position: 1)
        queue_item_bob2 = Fabricate(:queue_item, user: bob, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}, {id: queue_item_bob.id, position: 3}, {id: queue_item_bob2.id, position: 2}]
        expect(queue_item_bob.reload.position).to eq(1)
      end
    end
  end
end