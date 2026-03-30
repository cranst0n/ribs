import { watch, nextTick, onMounted } from 'vue'
import { useData } from 'vitepress'

/**
 * For pages with `outlineCollapsible: true` in frontmatter, collapses
 * nested h3 items in the "On this page" outline by default and adds
 * chevron toggles to expand/collapse each section.
 */
export function useOutlineCollapse() {
  const { frontmatter, page } = useData()

  onMounted(() => {
    watch(() => page.value.relativePath, () => {
      nextTick(() => setTimeout(applyCollapse, 150))
    }, { immediate: true })
  })

  function applyCollapse() {
    // Clean up previous toggles
    document.querySelectorAll('.outline-section-toggle').forEach(el => el.remove())
    document.querySelectorAll('.VPDocAsideOutline nav ul ul').forEach(ul => {
      ;(ul as HTMLElement).style.display = ''
    })

    if (!frontmatter.value.outlineCollapsible) return

    const nav = document.querySelector('.VPDocAsideOutline nav')
    if (!nav) return

    nav.querySelectorAll(':scope > ul > li').forEach(li => {
      const nested = li.querySelector(':scope > ul')
      if (!nested || nested.children.length === 0) return

      // Collapse by default
      ;(nested as HTMLElement).style.display = 'none'

      // Create chevron toggle
      const toggle = document.createElement('span')
      toggle.className = 'outline-section-toggle'
      toggle.textContent = '\u25B8' // ▸
      li.insertBefore(toggle, li.firstChild)

      toggle.addEventListener('click', (e) => {
        e.preventDefault()
        e.stopPropagation()
        const hidden = (nested as HTMLElement).style.display === 'none'
        ;(nested as HTMLElement).style.display = hidden ? '' : 'none'
        toggle.textContent = hidden ? '\u25BE' : '\u25B8' // ▾ / ▸
      })
    })
  }
}
