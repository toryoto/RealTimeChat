<template>
  <div class="container">
    <Navbar />
    <ChatWindow :messages="messages" />
  </div>
</template>

<script>
import Navbar from '../components/Navbar.vue'
import ChatWindow from '../components/ChatWindow'
import axios from 'axios'

export default {
  components: {
    Navbar,
    ChatWindow
  },
  data() {
    return {
      messages: [],
    }
  },
  methods: {
    async getMessages() {
      try {
        const res = await axios.get('http://localhost:3000/messages', {
          headers: {
            uid: window.localStorage.getItem('uid'),
            "access-token": window.localStorage.getItem('access-token'),
            client:window.localStorage.getItem('client')
          }
        })

        console.log(111111, res)
        if (!res) {
          new Error('メッセージ一覧を取得できませんでした')
        }

        this.messages = res.data
      } catch(error) {
        console.log(error)
      }
    }
  },
  // HTMLが表示される直前に実行するメソッド
  mounted() {
    this.getMessages()
  },
}
</script>

<style scoped>
</style>