<template>
  <div class="container">
    <Navbar />
    <ChatWindow @connectCable="connectCable" :messages="formattedMessages" ref="chatWindow" />
    <NewChatForm @connectCable="connectCable" />
  </div>
</template>

<script>
import Navbar from '../components/Navbar.vue'
import ChatWindow from '../components/ChatWindow'
import NewChatForm from '../components/NewChatForm'
import axios from 'axios'
import ActionCable from 'actioncable'
import { formatDistanceToNow } from 'date-fns'
import { ja } from 'date-fns/locale'

export default {
  components: {
    Navbar,
    ChatWindow,
    NewChatForm,
  },
  computed: {
    formattedMessages() {
      if (!this.messages.length) return []
      
      return this.messages.map(message => {
        let time = formatDistanceToNow(new Date(message.created_at), { locale: ja })
        return { ...message, created_at: time }
      })
    }
  },
  data() {
    return {
      messages: [],
    }
  },
  methods: {
    async getMessages() {
      try {
        const res = await axios.get('http://localhost:3000/api/messages', {
          headers: {
            uid: window.localStorage.getItem('uid'),
            "access-token": window.localStorage.getItem('access-token'),
            client:window.localStorage.getItem('client')
          }
        })

        if (!res) {
          new Error('メッセージ一覧を取得できませんでした')
        }

        this.messages = res.data
      } catch(error) {
        console.log(error)
      }
    },

    connectCable (message) {
      // this.messageChannelと接続しroom_channel.rbのreceiveメソッドを実行する
      this.messageChannel.perform('receive', {
        message: message,
        email: window.localStorage.getItem('uid')
      })
    }
  },

  // HTMLが表示される直前に実行するメソッド
  mounted () {
    // RailsのActionCableとコネクションを確立する
    const cable = ActionCable.createConsumer('ws://localhost:3000/cable')
    // RoomChannelという名前のチャンネルと常時接続状態にする（ルーム選択機能がないため）
    this.messageChannel = cable.subscriptions.create('RoomChannel', {
      connected: () => {
        this.getMessages().then(() => {
          // refはHTML要素取得と子コンポーネントアクセスに使う
          this.$refs.chatWindow.scrollToBottom()
        })
      },
      // Railsから何かデータが送られたときに実行
      received: () => {
        this.getMessages().then(() => {
          this.$refs.chatWindow.scrollToBottom()
        })
      }
    })
  },
  beforeUnmount () { 
    this.messageChannel.unsubscribe()
  }
}
</script>

<style scoped>
</style>