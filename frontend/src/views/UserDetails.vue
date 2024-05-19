<template>
  <div class="user-details-container">
    <h1>ユーザー詳細</h1>
    <button @click="goBack">戻る</button>
    <div v-if="user" class="user-info">
      <p><strong>ユーザー名:</strong> {{ user.name }}</p>
      <p><strong>メール:</strong> {{ user.email }}</p>
    </div>
    <div v-else>
      <p>ユーザー情報を読み込み中...</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      user: null,
      userId: this.$route.params.id
    };
  },
  mounted() {
    this.getUser();
  },
  methods: {
    async getUser() {
      try {
        const res = await axios.get(`http://localhost:3000/api/users/${this.userId}`, {
          headers: {
            uid: window.localStorage.getItem('uid'),
            "access-token": window.localStorage.getItem('access-token'),
            client:window.localStorage.getItem('client')
          }
        })

        if (!res) {
          console.error('Error fetching user');
        }

        this.user = res.data
      } catch(error) {
        console.log(error)
      }
    },
    goBack() {
      window.history.back();
    }
  }
};
</script>

<style scoped>
.user-details-container {
  background-color: #eafaf1;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  max-width: 600px;
  margin: 20px auto;
}

.user-details-container h1 {
  font-size: 24px;
  margin-bottom: 20px;
}

.user-info {
  background-color: #fff;
  padding: 15px;
  border-radius: 5px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.user-info p {
  margin: 10px 0;
}

.user-info p strong {
  color: #333;
}
</style>
