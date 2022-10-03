class MessagesController < ApplicationController
  authorize_resource
  before_action :get_followed_users
  before_action :get_messages, :login_room, only: %i(show)

  def index; end

  def show; end

  def create
    message = current_user.messages.build(message_params)
    if message.save
      partial_sender = "messages/mine"
      partial_receiver = "messages/their"
      ActionCable.server.broadcast "room_channel_#{@room_id}",
                                   html_sender: html(message,
                                                     partial_sender),
                                   html_receiver: html(message,
                                                       partial_receiver),
                                   sender: current_user.id,
                                   receiver: message.user_receive_id
    else
      render :show
    end
  end

  private

  def html message, partial
    render_to_string(partial: partial,
                     locals: {message: message})
  end

  def login_room
    prefix_one = current_user.id.to_i
    prefix_two = params[:id].to_i
    if prefix_one > prefix_two
      @room_id = "#{prefix_one}-#{prefix_two}"
    elsif prefix_one < prefix_two
      @room_id = "#{prefix_two}-#{prefix_one}"
    end
  end

  def get_followed_users
    @users = Relationship.accessible_by(current_ability).relationship_users
                         .includes(followed: :messages)
  end

  def get_messages
    @messages = Message.accessible_by(current_ability)
    @message  = current_user.messages.build
  end

  def message_params
    params.require(:message).permit(Message::CREATE_ATTRS)
  end
end
