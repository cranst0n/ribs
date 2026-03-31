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
  enhanceApp({ app, router }) {
    app.component('DartPad', DartPad)

    // Split-build cross-section navigation fix.
    //
    // The full site is built in sections (guide + one per API package), each
    // producing its own hashed app.js that only knows about its own routes.
    // VitePress's SPA router intercepts link clicks; if the destination route
    // isn't in the current bundle it renders a 404 instead of fetching the
    // page. Force a full page reload whenever navigation crosses section
    // boundaries so the correct app.js is loaded for the destination.
    if (typeof window !== 'undefined') {
      router.onBeforeRouteChange = (to) => {
        // Derive a section key from a URL path:
        //   /ribs/api/package-<name>/... → "package-<name>"
        //   everything else              → "guide"
        const section = (path: string) => {
          const m = path.match(/\/api\/(package-[^/?#]+)/)
          return m ? m[1] : 'guide'
        }
        if (section(window.location.pathname) !== section(to)) {
          window.location.href = to
          return false
        }
      }
    }
  },
  setup() {
    const { page } = useData()
    const pagePath = computed(() => page.value.relativePath)
    useCodeblockCollapse(pagePath)
    useMermaidZoom(pagePath)
    useOutlineCollapse()
  }
} satisfies Theme
