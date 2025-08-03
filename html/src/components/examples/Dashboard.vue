<!--
  Dashboard Component
  
  @description: Simple dashboard view for router example (not used in MainDemo)
  @author: Your Name
-->

<template>
  <div>
    <h3 class="text-lg font-semibold mb-2 dark:text-white">Dashboard</h3>
    <p class="text-gray-600 dark:text-gray-400 mb-4">Welcome to your FiveM dashboard!</p>
    
    <div class="grid grid-cols-2 gap-4">
      <div class="bg-blue-100 dark:bg-blue-900 p-3 rounded">
        <h4 class="font-medium dark:text-white">Quick Stats</h4>
        <p class="text-sm text-gray-600 dark:text-gray-400">Health: 100%</p>
        <p class="text-sm text-gray-600 dark:text-gray-400">Armor: 50%</p>
      </div>
      <div class="bg-green-100 dark:bg-green-900 p-3 rounded">
        <h4 class="font-medium dark:text-white">Money</h4>
        <p class="text-sm text-gray-600 dark:text-gray-400">Cash: $1,500</p>
        <p class="text-sm text-gray-600 dark:text-gray-400">Bank: $25,000</p>
      </div>
    </div>
    
    <div class="mt-4 p-3 bg-yellow-100 dark:bg-yellow-900 rounded">
      <p class="text-sm dark:text-yellow-200"><strong>Router Example:</strong> This is the Dashboard route (/)</p>
      <p class="text-xs text-gray-600 dark:text-gray-400">This component is for router examples only!</p>
    </div>
  </div>
</template>

<script setup>
/**
 * Dashboard Router Component
 * This is only used if you're using Vue Router
 * The MainDemo component has its own dashboard tab
 */
</script>
