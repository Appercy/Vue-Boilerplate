<template>
  <div class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
    <!-- Example UI Panel -->
    <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4 p-6">
      <!-- Header -->
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-bold text-gray-800">Example NUI Panel</h2>
        <button @click="closeUI" class="text-gray-500 hover:text-gray-700">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- Navigation (Router Example) -->
      <div class="flex space-x-2 mb-4 border-b pb-2">
        <router-link 
          to="/" 
          class="px-3 py-1 rounded text-sm"
          :class="$route.path === '/' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'"
        >
          Dashboard
        </router-link>
        <router-link 
          to="/inventory" 
          class="px-3 py-1 rounded text-sm"
          :class="$route.path === '/inventory' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'"
        >
          Inventory
        </router-link>
        <router-link 
          to="/settings" 
          class="px-3 py-1 rounded text-sm"
          :class="$route.path === '/settings' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'"
        >
          Settings
        </router-link>
      </div>

      <!-- Content Area (Router View) -->
      <div class="mb-4">
        <router-view />
      </div>

      <!-- Player Data Display -->
      <div v-if="playerData" class="bg-gray-100 p-4 rounded mb-4">
        <h3 class="font-semibold mb-2">Player Info</h3>
        <p><strong>Name:</strong> {{ playerData.playerName }}</p>
        <p><strong>Health:</strong> {{ playerData.health }}</p>
        <p><strong>Money:</strong> ${{ playerData.money }}</p>
        <p v-if="playerData.coords"><strong>Location:</strong> {{ playerData.coords.x }}, {{ playerData.coords.y }}, {{ playerData.coords.z }}</p>
      </div>

      <!-- Server Data Display -->
      <div v-if="serverData" class="bg-blue-100 p-4 rounded mb-4">
        <h3 class="font-semibold mb-2">Server Info</h3>
        <p><strong>Server:</strong> {{ serverData.serverName }}</p>
        <p><strong>Players Online:</strong> {{ serverData.onlinePlayers }}</p>
        <p><strong>Server Time:</strong> {{ serverData.serverTime }}</p>
      </div>

      <!-- Example Buttons -->
      <div class="space-y-2">
        <button @click="sendExampleData" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded">
          Get Player Data
        </button>
        <button @click="healPlayer" class="w-full bg-green-500 hover:bg-green-600 text-white py-2 px-4 rounded">
          Heal Player
        </button>
        <button @click="spawnVehicle" class="w-full bg-purple-500 hover:bg-purple-600 text-white py-2 px-4 rounded">
          Spawn Vehicle
        </button>
        <button @click="getServerData" class="w-full bg-orange-500 hover:bg-orange-600 text-white py-2 px-4 rounded">
          Get Server Data
        </button>
      </div>

      <!-- Notification -->
      <div v-if="notification" class="mt-4 p-3 rounded" :class="notificationClass">
        {{ notification.message }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

// Props for data from parent
const props = defineProps({
  playerData: Object,
  serverData: Object,
  notification: Object
})

// Emits for communicating back to parent
const emit = defineEmits(['close', 'sendExampleData', 'healPlayer', 'spawnVehicle', 'getServerData'])

// Computed notification class
const notificationClass = computed(() => {
  if (!props.notification) return ''
  
  const baseClasses = 'text-white font-medium'
  switch (props.notification.type) {
    case 'success':
      return `${baseClasses} bg-green-500`
    case 'error':
      return `${baseClasses} bg-red-500`
    case 'warning':
      return `${baseClasses} bg-yellow-500`
    default:
      return `${baseClasses} bg-blue-500`
  }
})

// Functions
function closeUI() {
  emit('close')
}

function sendExampleData() {
  emit('sendExampleData')
}

function healPlayer() {
  emit('healPlayer')
}

function spawnVehicle() {
  emit('spawnVehicle')
}

function getServerData() {
  emit('getServerData')
}
</script>

<style scoped>
/* Example component styles - you can remove this entire file to get a clean slate */
</style>
