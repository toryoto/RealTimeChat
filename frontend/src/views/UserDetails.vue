<template>
  <div class="user-details-container">
    <h1>ユーザー詳細</h1>
    <button @click="goBack" class="back-button">戻る</button>
    <div v-if="user" class="user-info">
      <div class="user-info-item">
        <p><strong>ユーザー名:</strong> <span>{{ user.name }}</span></p>
      </div>
      <div class="user-info-item">
        <p><strong>メール:</strong> <span v-if="isEmailPublic">{{ user.email }}</span></p>
      </div>
      <div class="user-info-item">
        <p><strong>メールアドレス公開:</strong>
          <Toggle v-model="isEmailPublic" @change="updateEmailVisibility" />
        </p>
      </div>
    </div>
    <div v-else>
      <p>ユーザー情報を読み込み中...</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import Toggle from '@vueform/toggle'

export default {
  components: {
      Toggle,
    },
  data() {
    return {
      user: null,
      userId: this.$route.params.id,
      isEmailPublic: null,
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
        this.isEmailPublic = res.data.is_email_public;
        console.log(this.isEmailPublic)
      } catch(error) {
        console.log(error)
      }
    },
    async updateEmailVisibility() {
      try {
        await axios.put(`http://localhost:3000/api/users/${this.userId}/email_visibility`, {
          user: {
            is_email_public: this.isEmailPublic
          }
        }, {
          headers: {
            uid: window.localStorage.getItem('uid'),
            "access-token": window.localStorage.getItem('access-token'),
            client:window.localStorage.getItem('client')
          }
        });
        
        await this.getUser()

      } catch (error) {
        console.log(error);
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
  position: relative;
}
.back-button {
  position: absolute;
  top: 20px;
  left: 20px;
  background-color: #4CAF50;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s;
}
.back-button:hover {
  background-color: #45a049;
}
.user-details-container h1 {
  font-size: 24px;
  margin-bottom: 20px;
  text-align: center;
}
.user-info {
  background-color: #fff;
  padding: 15px;
  border-radius: 5px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}
.user-info-item {
  margin: 10px 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.user-info-item p {
  display: flex;
  align-items: center;
}
.user-info-item strong {
  color: #333;
  margin-right: 10px;
  min-width: 120px;
}
.user-info-item span {
  color: #555;
  background-color: #f0f0f0;
  padding: 5px 10px;
  border-radius: 5px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}
</style>
