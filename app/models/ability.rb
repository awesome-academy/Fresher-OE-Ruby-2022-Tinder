# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :create, User

    return if user.blank?

    can %i(read update), User, id: user.id
    can :create, Relationship
    can %i(read create), Message, user_send_id: user.id
    can :read, Message, user_receive_id: user.id

    return unless user.gold?

    can :update, Relationship, follower_id: user.id

    return unless user.admin

    can :manage, :AdminPagesController
    can :destroy, User
  end
end
