<template>
  <div class="chat-window">
    <div v-if="messages" class="messages" ref="messages">
      <ul v-for="message in messages" :key="message.id">
        <li :class="{ received: message.email !== uid, sent: message.email === uid }">
          <span class="name"><router-link :to="{ name: 'UserDetails', params: { id: message.user_id }}">{{ message.name }}</router-link></span>
          <div class="message" @dblclick="handleLike(message)" @contextmenu.prevent="openContextMenu(message)" v-click-out-side="closeContextMenu">
            {{ message.content }}
            <div v-if="message.id === contextMenuMessageId  && message.email === uid" class="context-menu">
              <button @click="openEditModal(message)">編集</button>
              <button @click="deleteMessage(message.id)">削除</button>
            </div>
            <div v-if="message.likes.length" class="heart-container">
              <font-awesome-icon icon="heart" class="heart" />
              <span class="heart-count">{{ message.likes.length }}</span>
            </div>
          </div>
          <span class="created-at">{{ message.created_at }}前</span>
        </li>
      </ul>
    </div>
  </div>
  <MessageEditModal v-show="isOpenEditModal" :message="messageToEdit" @close="closeEditModal" />
</template>

<script>
import MessageEditModal from '../components/MessageEditModal.vue'
import clickOutSide from "@mahdikhashan/vue3-click-outside"
import axios from 'axios'

export default {
  components: {
    MessageEditModal
  },
  directives: {
    clickOutSide,
  },
  emits: ['connectCable'],
  props: ["messages"],
  data() {
    return {
      uid: localStorage.getItem('uid'),
      contextMenuMessageId: null,
      isOpenEditModal: false,
      messageToEdit: null,
    }
  },
  methods: {
    openContextMenu(message) {
      this.contextMenuMessageId = message.id;
    },
    closeContextMenu() {
      this.contextMenuMessageId = null
    },
    openEditModal(message) {
      this.messageToEdit = message
      console.log(this.messageToEdit.content, 111)
      this.isOpenEditModal = true
    },
    closeEditModal() {
      this.$emit('connectCable')
      this.isOpenEditModal = false
    },
    async deleteMessage(messageId) {
      try {
        const res = await axios.delete(`http://localhost:3000/api/messages/${messageId}`, {
          headers: {
            uid: this.uid,
            "access-token": window.localStorage.getItem('access-token'),
            client: window.localStorage.getItem('client')
          }
        })

        if(!res) new Error('削除できませんでした')

        this.$emit('connectCable')
        this.showContextMenu = false
      } catch (error) {
        console.log(error)
      }
    },
    handleLike(message) {
      for (let i = 0; i < message.likes.length; i++) {
        const like = message.likes[i]
        if (like.email === this.uid) {
          this.deleteLike(like.id)
          return
        }
      }
      this.createLike(message.id)
    },
    async createLike(messageId) {
      try {
        // POSTメソッドでヘッダー情報付与するときは第三引数
        const res = await axios.post(`http://localhost:3000/api/messages/${messageId}/likes`, {}, {
          headers: {
            uid: this.uid,
            "access-token": window.localStorage.getItem('access-token'),
            client: window.localStorage.getItem('client')
          }
        })
        
        if(!res) new Error('いいねできませんでした')

        // いいねをしたらActionCableにつないでリアクティブに表示する
        this.$emit('connectCable')
      } catch(error) {
        console.log(error)
      }
    },
    async deleteLike(likeId) {
      try {
        const res  = await axios.delete(`http://localhost:3000/api/likes/${likeId}`, {
          headers: {
            uid: this.uid,
            "access-token": window.localStorage.getItem("access-token"),
            client: window.localStorage.getItem('client')
          }
        })

        if (!res) new Error('いいねを削除できませんでした')

        this.$emit('connectCable')
      } catch(error) {
        console.log(error)
      }
    },
    // 画面を下までスクロールするメソッド（メッセージ作成時に実行する）
    scrollToBottom() {
      const element = this.$refs.messages
      element.scrollTop = element.scrollHeight
    }
  },
}
</script>

<style scoped>
  .chat-window {
    background: white;
    padding: 30px 20px;
    border-bottom: 1px solid #eee;
  }
  ul {
    list-style: none;
    margin: 0;
    padding: 0;
  }
  ul li {
    display:inline-block;
    clear: both;
  }
  .received .message {
    background: #eee;
    padding: 10px;
    display: inline-block;
    border-radius: 30px;
    margin-bottom: 2px;
    max-width: 400px;
  }
  .received {
    float: left;
  }
  .sent {
    float: right;
  }
  .sent .message {
    background: #677bb4;
    color: white;
    padding: 10px;
    display: inline-block;
    border-radius: 30px;
    margin-bottom: 2px;
    max-width: 400px;
  }
  .name {
    position: relative;
    margin-right: 6px;
    display: block;
    font-size: 13px;
  }
  .created-at {
    display: block;
    color: #999;
    font-size: 12px;
    margin-bottom: 20px;
    margin-left: 4px;
  }
  .messages {
    max-height: 400px;
    overflow: auto;
  }
  .message {
    position: relative;
  }

  .heart-container {
    background: white;
    position: absolute;
    display: flex;
    justify-content: space-around;
    align-items: center;
    border-radius: 30px;
    min-width: 25px;
    border-style: solid;
    border-width: 1px;
    border-color: rgb(245, 245, 245);
    padding: 1px 2px;
    z-index: 2;
    bottom: -7px;
    right: 0px;
    font-size: 9px;
  }
  .heart {
    color: rgb(236, 29, 29);
  }
  .heart-count {
    color: rgb(20, 19, 19);
  }
  .received .message::selection {
    background: #eee;
  }
  .sent .message::selection {
    background: #677bb4;
  }
  .context-menu {
    position: absolute;
    background-color: #f9f9f9;
    min-width: 150px;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    z-index: 1;
    border-radius: 5px;
  }
  .sent .context-menu {
    right: 100px;
  }
  .context-menu button {
    background-color: transparent;
    border: none;
    color: black;
    text-align: left;
    cursor: pointer;
    width: 100%;
    padding: 10px 20px;
    text-decoration: none;
    display: block;
  }
  .context-menu button:hover {
    background-color: #f1f1f1;
  }
  .name a {
    color: inherit;
    text-decoration: none;
  }
  .name a:hover {
    text-decoration: underline;
  }
</style>