class FriendshipsController < ApplicationController
    before_action :authenticate_user!

    def index
        @friends = current_user.friends
        @requests = current_user.requests
    end
    
    
    def create
        # @friendship = current_user.friendship.build()
        @friendship = current_user.friendships.build(friend_id: params[:friend_id])
        @friendship.save
        # format.html { redirect_to user_url(id: params[:friend_id]) }
        redirect_to user_url(id: params[:friend_id])
    end

    def update
        @friendship = Friendship.find(params[:id])
        @friendship.update(status: true)
        # format.html { redirect_to friendships_path }
        redirect_to friendships_path
    end

    def destroy
        @friendship = Friendship.find(params[:id])
        @friendship.destroy
        # format.html { redirect_to friendships_path }
        redirect_to friendships_path
    end

end
