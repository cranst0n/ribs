import { computed, h } from 'vue'
import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import { useData } from 'vitepress'
import { useCodeblockCollapse } from 'vitepress-codeblock-collapse'
import 'vitepress-codeblock-collapse/style.css'
import { useMermaidZoom } from 'vitepress-mermaid-zoom'
import 'vitepress-mermaid-zoom/style.css'
import './custom.css'
import '../generated/api-styles.css'
import DartPad from './components/DartPad.vue'
import ApiBreadcrumb from './components/ApiBreadcrumb.vue'
import { useOutlineCollapse } from './composables/useOutlineCollapse'

export default {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      'doc-before': () => h(ApiBreadcrumb),
    })
  },
  enhanceApp({ app }) {
    app.component('DartPad', DartPad)
  },
  setup() {
    const { page } = useData()
    const pagePath = computed(() => page.value.relativePath)
    useCodeblockCollapse(pagePath)
    useMermaidZoom(pagePath)
    useOutlineCollapse()
  }
} satisfies Theme
