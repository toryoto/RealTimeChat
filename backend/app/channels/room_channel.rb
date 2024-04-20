class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # Vueからemail,messageを含んだデータが送られてくる
    user = User.find_by(email: data['email'])
    if message = Message.create(content: data['message'], user_id: user.id)
      #room_channelチャネルに接続しているWebブラウザ全てにデータを送信するためのメソッド
      ActionCable.server.broadcast 'room_channel', { message: data['message'], name: user.name, created_at: message.created_at }
    end
  end
end
