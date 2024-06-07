<template>
  <div>
    <h2>ログイン</h2>
    <form @submit.prevent="login">
      <input type="email" required placeholder="メールアドレス" v-model="email" autocomplete="email">
      <input type="password" required placeholder="パスワード" v-model="password" autocomplete="password">
      <div class="error">{{ error }}</div>
      <button>ログインする</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios'
import setItem from '../auth/setItem'

export default {
  emits: ['redirectToChatRoom'],
  data () {
    return {
      email: '',
      password: '',
      error: null,
    }
  },
  methods: {
    async login() {
      try {
        this.error = null
        const res = await axios.post('http://localhost:3000/api/auth/sign_in', {
          email: this.email,
          password: this.password
        })
        if (!res) {
          throw new Error('メールアドレスかパスワードが違います')
        } 
        if (this.error == null) {
          console.log({ res })
          // console.log(res.headers['access-token'])
          setItem(res.headers, res.data.data.name)
          window.localStorage.setItem('user_id', res.data.data.id)
          this.$emit('redirectToChatRoom')
        }
      } catch(error) {
        // console.log(error)
        this.error = 'メールアドレスかパスワードが違います'
      }
    }
  },
}
</script>