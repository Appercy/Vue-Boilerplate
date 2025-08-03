import './assets/base.css'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

// Create and mount the Vue app with router
const app = createApp(App)
app.use(router)

// Make router available globally for FiveM navigation
window.vueRouter = router

app.mount('#app')





