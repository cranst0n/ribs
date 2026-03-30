<script setup lang="ts">
import { ref, computed, watch, onBeforeUnmount } from 'vue'
import { useData } from 'vitepress'

const props = withDefaults(defineProps<{
  code: string
  mode?: 'dart' | 'flutter'
  height?: number
  run?: boolean
}>(), {
  mode: 'dart',
  height: 400,
  run: true,
})

const isClient = typeof window !== 'undefined'

const { isDark } = useData()

const decodedCode = computed(() => {
  if (!isClient) return props.code
  try {
    return atob(props.code)
  } catch {
    return props.code
  }
})

const active = ref(false)
const loading = ref(false)
const iframe = ref<HTMLIFrameElement | null>(null)
const copied = ref(false)

const theme = computed(() => isDark.value ? 'dark' : 'light')

const ALLOWED_ORIGINS = [
  'https://dartpad.dev',
  'https://www.dartpad.dev',
  'https://dartpad.cn',
  'https://www.dartpad.cn',
]

const dartpadUrl = computed(() => {
  const params = new URLSearchParams({
    embed: 'true',
    theme: theme.value,
  })
  if (props.run) {
    params.set('run', 'true')
  }
  return `https://dartpad.dev/?${params.toString()}`
})

function handleMessage(e: MessageEvent) {
  if (!ALLOWED_ORIGINS.includes(e.origin)) return
  if (!e.data || typeof e.data !== 'object' || typeof e.data.type !== 'string') return

  if (e.data.type === 'ready' && iframe.value?.contentWindow) {
    loading.value = false
    iframe.value.contentWindow.postMessage(
      { sourceCode: decodedCode.value, type: 'sourceCode' },
      e.origin
    )
  }
}

function openPlayground() {
  active.value = true
  loading.value = true
  if (isClient) {
    window.addEventListener('message', handleMessage)
  }
}

function closePlayground() {
  active.value = false
  loading.value = false
  if (isClient) {
    window.removeEventListener('message', handleMessage)
  }
}

async function copyCode() {
  if (!isClient) return
  try {
    await navigator.clipboard.writeText(decodedCode.value)
    copied.value = true
    setTimeout(() => { copied.value = false }, 2000)
  } catch {
    // Clipboard API not available
  }
}

// Reload iframe when theme changes while playground is active.
watch(theme, () => {
  if (active.value && iframe.value) {
    loading.value = true
    iframe.value.src = dartpadUrl.value
  }
})

onBeforeUnmount(() => {
  if (isClient) {
    window.removeEventListener('message', handleMessage)
  }
})
</script>

<template>
  <div class="dartpad-wrapper">
    <template v-if="!active">
      <div class="dartpad-code">
        <slot></slot>
      </div>
      <div class="dartpad-toolbar">
        <button class="dartpad-btn dartpad-run" @click="openPlayground" title="Run in DartPad" aria-label="Run in DartPad">
          Run <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
        </button>
        <button
          class="dartpad-btn dartpad-copy"
          @click="copyCode"
          :title="copied ? 'Copied!' : 'Copy code'"
          :aria-label="copied ? 'Code copied to clipboard' : 'Copy code to clipboard'"
        >
          <svg v-if="!copied" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
          <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
        </button>
      </div>
    </template>
    <template v-else>
      <div class="dartpad-active">
        <div class="dartpad-active-toolbar">
          <span class="dartpad-label">
            {{ loading ? 'Loading DartPad\u2026' : 'DartPad' }}
          </span>
          <button class="dartpad-btn dartpad-close" @click="closePlayground" title="Close playground" aria-label="Close playground">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
          </button>
        </div>
        <div class="dartpad-iframe-container" :style="{ height: props.height + 'px' }">
          <div v-if="loading" class="dartpad-loader">
            <span class="dartpad-spinner"></span>
            <span class="dartpad-loader-text">Loading DartPad…</span>
          </div>
          <iframe
            ref="iframe"
            :src="dartpadUrl"
            class="dartpad-iframe"
            sandbox="allow-scripts allow-same-origin allow-popups allow-forms"
            allow="clipboard-write"
          ></iframe>
        </div>
      </div>
    </template>
  </div>
</template>
