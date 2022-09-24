class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def destroy
    user = Relationship.find_by(params[:id]).followed
    current_user.unfollow(user)
    ids = [user.id, current_user.id]
    relationship = Relationship.by_follower(ids).by_followed(ids)
    relationship.update_all(status: false)
    redirect_to current_user
  end
end