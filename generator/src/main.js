import Vue from 'vue'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import App from './App.vue'
import axios from 'axios';
const apiBaseUrl = window.appConfig.apiBaseUrl;

// Set axios base URL
axios.defaults.baseURL = apiBaseUrl;


Vue.use(ElementUI);
Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).$mount('#app')
