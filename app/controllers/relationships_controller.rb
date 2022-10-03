class RelationshipsController < ApplicationController
  # authorize_resource
  before_action :authenticate_user!

  def destroy
    user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow(user)
    ids = [user.id, current_user.id]
    relationship = Relationship.by_follower(ids).by_followed(ids)
    can? :update, relationship
    relationship.update_all(status: false)
    redirect_to current_user
  end
end
