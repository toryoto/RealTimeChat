class MessagesController < ApplicationController
  before_action :authenticate_user!, only: ["index"]

  def index
    messages = Message.eager_load(:user, [likes: :user])
    messages_array = messages.map do |message|
      {
        id: message.id,
        user_id: message.user.id,
        name: message.user.name,
        content: message.content,
        email: message.user.email,
        created_at: message.created_at,
        # likesレコードを二次元配列で保持する
        likes: message.likes.map { |like| {id: like.id, email: like.user.email} }
      }
    end

    render json: messages_array, status: :ok
  end

  def destroy
    message = Message.find(params[:id])

    if message.user_id == current_user.id
      message.destroy
      head :no_content
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
