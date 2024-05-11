<template>
  <div class="modal" v-show="isOpenEditModal" @click.self="closeModal">
    <div class="modal-content">
      <span class="close-button" @click="closeModal">×</span>
      <h2>メッセージを編集</h2>
      <textarea v-model="editedMessage" rows="4" cols="50"></textarea>
      <button @click="updateMessage">更新</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  props: ['isOpenEditModal', 'message'],
  data() {
    return {
      editedMessage: null
    }
  },
  methods: {
    closeModal() {
      this.$emit('close')
    },
    async updateMessage() {
      try {
        const res = await axios.put(`http://localhost:3000/api/messages/${this.message.id}`, { content: this.editedMessage }, {
          headers: {
            uid: localStorage.getItem('uid'),
            "access-token": window.localStorage.getItem('access-token'),
            client: window.localStorage.getItem('client')
          }
        })

        if(!res) new Error('更新できませんでした')

        this.$emit('close')

      } catch (error) {
        console.log(error)
      }
    }
  },
  mounted() {
    this.editedMessage = this.message
  },
}
</script>

<style scoped>
.modal {
  position: fixed;
  z-index: 1;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  overflow: auto;
  background-color: rgba(0,0,0,0.4);
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-content {
  background-color: #fefefe;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 50%;
  box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
  animation-name: animatetop;
  animation-duration: 0.4s;
}

@keyframes animatetop {
  from {top: -300px; opacity: 0}
  to {top: 0; opacity: 1}
}

.close-button {
  color: #aaaaaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close-button:hover,
.close-button:focus {
  color: #000;
  text-decoration: none;
  cursor: pointer;
}

</style>