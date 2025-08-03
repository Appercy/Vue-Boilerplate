/**
 * Vue Router Configuration
 * Clean setup with only Dashboard and Settings routes
 * 
 * @description: Simple routing for demo UI tabs
 * @author: Your Name
 */

import { createRouter, createWebHashHistory } from 'vue-router'

// Clean router with only Dashboard and Settings
const router = createRouter({
  // Use hash history for better FiveM compatibility
  history: createWebHashHistory(),

  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: () => import('../components/examples/Dashboard.vue')
    },
    {
      path: '/settings',
      name: 'settings',
      component: () => import('../components/examples/Settings.vue')
    }
  ]
})

export default router