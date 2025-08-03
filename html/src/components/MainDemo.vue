<!--
  Clean Demo UI Component
  
  @description: Simple UI with Dashboard and Settings tabs only
  @author: Your Name
-->

<template>
  <div 
    class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50"
    :style="{ fontSize: settings.uiScale + 'rem' }"
  >
    <!-- Main UI Panel -->
    <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4 p-6 transition-colors">
      <!-- Header -->
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-bold text-gray-800">FiveM Dashboard</h2>
        <button 
          @click="closeUI" 
          class="text-gray-500 hover:text-gray-700"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- Navigation Tabs -->
      <div class="flex space-x-2 mb-4 border-b pb-2">
        <button 
          @click="currentTab = 'dashboard'"
          class="px-3 py-1 rounded text-sm transition-colors"
          :class="currentTab === 'dashboard' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'"
        >
          Dashboard
        </button>
        <button 
          @click="currentTab = 'settings'"
          class="px-3 py-1 rounded text-sm transition-colors"
          :class="currentTab === 'settings' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'"
        >
          Settings
        </button>
      </div>

      <!-- Dashboard Tab Content -->
      <div v-if="currentTab === 'dashboard'" class="mb-4">
        <h3 class="text-lg font-semibold mb-2 text-gray-800">Dashboard</h3>
        <p class="text-gray-600 mb-4">Welcome to your FiveM dashboard!</p>
        
        <!-- Player Data Display -->
        <div v-if="playerData" class="bg-gray-100 p-4 rounded mb-4">
          <h4 class="font-semibold mb-2 text-gray-800">Player Info</h4>
          <div class="space-y-1 text-sm">
            <p class="text-gray-700"><strong>Name:</strong> {{ playerData.name || playerData.playerName }}</p>
            <p class="text-gray-700"><strong>Health:</strong> {{ playerData.health }}%</p>
            <p class="text-gray-700"><strong>Cash:</strong> ${{ formatNumber(playerData.money) }}</p>
            <p v-if="playerData.bank" class="text-gray-700"><strong>Bank:</strong> ${{ formatNumber(playerData.bank) }}</p>
            <p v-if="playerData.job" class="text-gray-700"><strong>Job:</strong> {{ playerData.jobLabel || playerData.job }} (Grade {{ playerData.grade || 0 }})</p>
            <p v-if="playerData.framework" class="text-gray-700">
              <strong>Framework:</strong> 
              <span class="px-2 py-1 bg-blue-500 text-white text-xs rounded">{{ playerData.framework }}</span>
            </p>
          </div>
        </div>

        <!-- Server Data Display -->
        <div v-if="serverData" class="bg-blue-100 p-4 rounded mb-4">
          <h4 class="font-semibold mb-2 text-gray-800">Server Info</h4>
          <div class="space-y-1 text-sm">
            <p class="text-gray-700"><strong>Server:</strong> {{ serverData.serverName }}</p>
            <p class="text-gray-700"><strong>Players:</strong> {{ serverData.onlinePlayers }}{{ serverData.maxPlayers ? '/' + serverData.maxPlayers : '' }}</p>
            <p class="text-gray-700"><strong>Time:</strong> {{ serverData.serverTime }}</p>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="space-y-2">
          <button 
            @click="getData" 
            class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded transition-colors"
          >
            Get Data
          </button>
          <button 
            @click="healPlayer" 
            class="w-full bg-green-500 hover:bg-green-600 text-white py-2 px-4 rounded transition-colors"
          >
            Heal Player
          </button>
          <button 
            @click="spawnVehicle" 
            class="w-full bg-purple-500 hover:bg-purple-600 text-white py-2 px-4 rounded transition-colors"
          >
            Spawn Vehicle
          </button>
        </div>
      </div>

      <!-- Settings Tab Content -->
      <div v-if="currentTab === 'settings'" class="mb-4">
        <h3 class="text-lg font-semibold mb-2 text-gray-800">Settings</h3>
        <p class="text-gray-600 mb-4">Configure your UI preferences</p>
        
        <div class="space-y-4">
          <!-- UI Scale Setting -->
          <div>
            <label class="text-sm font-medium block mb-2 text-gray-700">
              UI Scale: {{ settings.uiScale }}x
            </label>
            <input 
              type="range" 
              v-model.number="settings.uiScale" 
              min="0.8" 
              max="1.5" 
              step="0.1" 
              class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
              @input="saveSettings"
            >
            <div class="flex justify-between text-xs text-gray-500 mt-1">
              <span>Small</span>
              <span>Normal</span>
              <span>Large</span>
            </div>
          </div>
        </div>
        
        <!-- Settings Actions -->
        <div class="mt-6 space-y-2">
          <div class="flex space-x-2">
            <button 
              @click="resetSettings"
              class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded text-sm transition-colors"
            >
              Reset to Default
            </button>
            <button 
              @click="exportSettings"
              class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded text-sm transition-colors"
            >
              Export to F8 Console
            </button>
          </div>
          <p class="text-xs text-gray-500">
            💡 Export logs settings to browser console (F12) as JSON for backup/sharing
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * Clean Demo UI with Dashboard and Settings
 * Features localStorage settings persistence
 */

import { ref, onMounted, watch } from 'vue'

// Props from parent component
const props = defineProps({
  playerData: Object,
  serverData: Object
})

// Emits for parent communication
const emit = defineEmits(['close', 'getData', 'healPlayer', 'spawnVehicle'])

// Component state
const currentTab = ref('dashboard')

/**
 * Default settings configuration (only UI scale)
 */
const defaultSettings = {
  uiScale: 1.0        // UI scaling factor (0.8 - 1.5)
}

/**
 * Current settings (reactive)
 */
const settings = ref({ ...defaultSettings })

/**
 * Load settings from localStorage on component mount
 */
function loadSettings() {
  try {
    const saved = localStorage.getItem('fivem-ui-settings')
    if (saved) {
      const parsed = JSON.parse(saved)
      settings.value = { ...defaultSettings, ...parsed }
      console.log('Settings loaded from localStorage:', settings.value)
    }
  } catch (error) {
    console.error('Failed to load settings:', error)
    settings.value = { ...defaultSettings }
  }
}

/**
 * Save settings to localStorage
 */
function saveSettings() {
  try {
    localStorage.setItem('fivem-ui-settings', JSON.stringify(settings.value))
    console.log('Settings saved to localStorage:', settings.value)
  } catch (error) {
    console.error('Failed to save settings:', error)
  }
}

/**
 * Reset settings to default values
 */
function resetSettings() {
  settings.value = { ...defaultSettings }
  saveSettings()
  console.log('Settings reset to default')
}

/**
 * Export settings as JSON for console logging (no clipboard access needed)
 */
function exportSettings() {
  const settingsJson = JSON.stringify(settings.value, null, 2)
  console.log('=== FIVEM UI SETTINGS EXPORT ===')
  console.log(settingsJson)
  console.log('================================')
  
  // Show success message
  console.log('Settings exported to F8 console successfully!')
}

/**
 * Format numbers with commas for better readability
 * @param {number} num - Number to format
 * @returns {string} Formatted number
 */
function formatNumber(num) {
  return num ? num.toLocaleString() : '0'
}

/**
 * Close the UI
 */
function closeUI() {
  emit('close')
}

/**
 * Get data from server
 */
function getData() {
  emit('getData')
}

/**
 * Heal the player
 */
function healPlayer() {
  emit('healPlayer')
}

/**
 * Spawn a vehicle
 */
function spawnVehicle() {
  emit('spawnVehicle')
}

// Component lifecycle
onMounted(() => {
  loadSettings()
})

// Watch for settings changes and auto-save
watch(settings, () => {
  saveSettings()
}, { deep: true })
</script>

<style scoped>
/* Custom slider styling */
input[type="range"]::-webkit-slider-thumb {
  appearance: none;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #3b82f6;
  cursor: pointer;
}

input[type="range"]::-moz-range-thumb {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #3b82f6;
  cursor: pointer;
  border: none;
}
</style>
