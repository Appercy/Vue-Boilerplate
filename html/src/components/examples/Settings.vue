<!--
  Settings Component
  
  @description: Simple settings view for router example (only UI scale)
  @author: Your Name
-->

<template>
  <div>
    <h3 class="text-lg font-semibold mb-2 dark:text-white">Settings</h3>
    <p class="text-gray-600 dark:text-gray-400 mb-4">Configure UI scale preference</p>
    
    <div class="space-y-3">
      <div>
        <label class="text-sm font-medium block mb-1 dark:text-gray-300">UI Scale</label>
        <input 
          type="range" 
          v-model="settings.uiScale" 
          min="0.8" 
          max="1.5" 
          step="0.1" 
          class="w-full"
        >
        <span class="text-xs text-gray-500 dark:text-gray-400">{{ settings.uiScale }}x</span>
      </div>
    </div>
    
    <div class="mt-4 flex space-x-2">
      <button 
        @click="saveSettings" 
        class="bg-blue-500 text-white px-3 py-1 rounded text-sm hover:bg-blue-600"
      >
        Save Settings
      </button>
      <button 
        @click="resetSettings" 
        class="bg-gray-300 text-gray-700 px-3 py-1 rounded text-sm hover:bg-gray-400 dark:bg-gray-600 dark:text-gray-300"
      >
        Reset
      </button>
    </div>
    
    <div class="mt-4 p-3 bg-yellow-100 dark:bg-yellow-900 rounded">
      <p class="text-sm dark:text-yellow-200"><strong>Router Example:</strong> This is the Settings route (/settings)</p>
      <p class="text-xs text-gray-600 dark:text-gray-400">This component is for router examples only!</p>
    </div>
  </div>
</template>

<script setup>
/**
 * Settings Router Component
 * This is only used if you're using Vue Router
 * The MainDemo component has its own settings tab with localStorage
 */

import { ref, onMounted } from 'vue'

// Settings with only UI scale
const settings = ref({
  uiScale: 1.0
})

/**
 * Load settings from localStorage
 */
function loadSettings() {
  const saved = localStorage.getItem('nui-settings')
  if (saved) {
    const parsed = JSON.parse(saved)
    settings.value.uiScale = parsed.uiScale || 1.0
  }
}

/**
 * Save settings to localStorage
 */
function saveSettings() {
  localStorage.setItem('nui-settings', JSON.stringify(settings.value))
  console.log('Settings saved:', settings.value)
}

/**
 * Reset settings to default
 */
function resetSettings() {
  settings.value.uiScale = 1.0
  saveSettings()
}

// Load settings on component mount
onMounted(() => {
  loadSettings()
})
</script>
