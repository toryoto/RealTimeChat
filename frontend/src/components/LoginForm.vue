<template>
  <div>
    <h2>ログイン</h2>
    <form @submit.prevent="login">
      <input type="email" required placeholder="メールアドレス" v-model="email">
      <input type="password" required placeholder="パスワード" v-model="password">
      <div class="error">{{ error }}</div>
      <button>ログインする</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  emits: ['redirectToChatRoom'],
  data () {
    return {
      email: '',
      password: ''
    }
  },
  async login() {
    try {
      this.error = null
      const res = await axios.post('http://localhost:3000/auth/sign_in', {
        email: this.email,
        password: this.password
      })
      if (!res) {
        throw new Error('メールアドレスかパスワードが違います')
      } 
      if (this.error == null) {
        this.$emit('redirectToChatRoom')
      }
    } catch(error) {
      // console.log(error)
      this.error = 'メールアドレスかパスワードが違います'
    }
  }
}
</script>