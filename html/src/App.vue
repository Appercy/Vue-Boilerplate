<!--
  Main App Component
  
  @description: Root Vue component that handles NUI communication
  @author: Your Name
-->

<template>
  <div id="app">
    <!-- Clean Demo UI Component - Dashboard and Settings only -->
    <MainDemo 
      v-if="isVisible"
      :playerData="playerData"
      :serverData="serverData" 
      @close="closeUI"
      @getData="getData"
      @healPlayer="healPlayer"
      @spawnVehicle="spawnVehicle"
    />

    <!-- 
    Custom UI Template (uncomment after removing MainDemo.vue):
    
    <div v-if="isVisible" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
      <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4 p-6">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-bold text-gray-800">My Custom NUI</h2>
          <button @click="closeUI" class="text-gray-500 hover:text-gray-700">×</button>
        </div>
        
        <div class="space-y-4">
          <p>Your UI content goes here!</p>
          <button @click="closeUI" class="w-full bg-blue-500 text-white py-2 px-4 rounded">
            Close
          </button>
        </div>
      </div>
    </div>
    -->
  </div>
</template>

<script setup>
/**
 * Vue 3 Composition API Setup
 * Handles NUI communication and state management
 */

import { ref, onMounted } from 'vue'
import MainDemo from './components/MainDemo.vue'

// Reactive state
const isVisible = ref(false) // UI hidden by default for FiveM
const playerData = ref(null) // Player data from server
const serverData = ref(null) // Server info from server

// Development mode detection
const isDevelopment = import.meta.env.DEV && (window.location.protocol === 'http:' || window.location.protocol === 'https:')
if (isDevelopment) {
  // Show UI in browser for easier development
  isVisible.value = true
}

/**
 * Closes the NUI and removes focus
 */
function closeUI() {
  isVisible.value = false
  
  // Tell FiveM to close UI
  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({})
  })
}

/**
 * Gets all data from server (player + server info)
 */
function getData() {
  console.log('Getting data from server...')
  
  const resourceName = GetParentResourceName()
  const url = `https://${resourceName}/getData`
  
  fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({})
  })
  .then(response => {
    if (response.ok) {
      return response.text().then(text => {
        return text ? JSON.parse(text) : {}
      })
    }
    throw new Error(`Request failed: ${response.status}`)
  })
  .then(data => {
    console.log('Got data:', data)
    if (data && data.message) {
      console.log('Server message:', data.message)
    }
  })
  .catch(error => {
    console.error('Error getting data:', error)
  })
}

/**
 * Heals the player
 */
function healPlayer() {
  console.log('Healing player...')
  
  const resourceName = GetParentResourceName()
  const url = `https://${resourceName}/healPlayer`
  
  fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({})
  })
  .then(response => {
    if (response.ok) {
      return response.text().then(text => {
        return text ? JSON.parse(text) : {}
      })
    }
    throw new Error(`Request failed: ${response.status}`)
  })
  .then(data => {
    console.log('Heal response:', data)
    if (data && data.message) {
      console.log('Server message:', data.message)
    }
  })
  .catch(error => {
    console.error('Error healing player:', error)
  })
}

/**
 * Spawns a vehicle for the player
 */
function spawnVehicle() {
  console.log('Spawning vehicle...')
  
  const resourceName = GetParentResourceName()
  const url = `https://${resourceName}/spawnVehicle`
  
  fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ model: 'adder' })
  })
  .then(response => {
    if (response.ok) {
      return response.text().then(text => {
        return text ? JSON.parse(text) : {}
      })
    }
    throw new Error(`Request failed: ${response.status}`)
  })
  .then(data => {
    console.log('Spawn response:', data)
    if (data && data.message) {
      console.log('Server message:', data.message)
    }
  })
  .catch(error => {
    console.error('Error spawning vehicle:', error)
  })
}

/**
 * Gets the FiveM resource name
 * @returns {string} Resource name
 */
function GetParentResourceName() {
  if (window.GetParentResourceName) {
    return window.GetParentResourceName()
  }
  // Fallback for development
  return 'NUI-Boilerplate'
}

/**
 * Listen for messages from FiveM client
 */
onMounted(() => {
  window.addEventListener('message', (event) => {
    const { action, data, route } = event.data

    switch (action) {
      case 'show':
        isVisible.value = true
        break
        
      case 'hide':
        isVisible.value = false
        break
        
      case 'navigateTo':
        // Router navigation (if using Vue Router)
        if (route && window.vueRouter) {
          window.vueRouter.push(route)
          if (data) {
            console.log('Navigation data:', data)
          }
        }
        break
        
      case 'updatePlayerData':
        playerData.value = data
        break
        
      case 'updateServerData':
        serverData.value = data
        break
    }
  })

  // Handle escape key to close UI
  window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && isVisible.value) {
      closeUI()
    }
  })
})
</script>

<style scoped>
/* Component styles go here */
</style>
