<script setup lang="ts">
import { computed, ref } from 'vue'
import { useData, withBase } from 'vitepress'

const { frontmatter, page, site } = useData()

const libraryDirName = computed(() => {
  const parts = page.value.relativePath.split('/')
  if (parts.length >= 2 && parts[0] === 'api') {
    return parts[1]
  }
  return null
})

const libraryDisplayName = computed(() => {
  return frontmatter.value.library ?? frontmatter.value.title ?? libraryDirName.value
})

const category = computed(() => frontmatter.value.category ?? null)

const pageTitle = computed(() => frontmatter.value.title ?? null)

const sourceUrl = computed(() => frontmatter.value.sourceUrl ?? null)

const isHomePage = computed(() => frontmatter.value.layout === 'home')

const isLibraryOverview = computed(() => {
  return page.value.relativePath.endsWith('/index.md') &&
    page.value.relativePath.startsWith('api/') &&
    page.value.relativePath.split('/').length === 3
})

const packageName = computed(() => {
  // Site title is "PackageName API" — extract just the name.
  const title = site.value.title ?? ''
  return title.replace(/ API$/, '') || title
})

const copied = ref(false)

async function copyPage() {
  const doc = document.querySelector('.vp-doc')
  if (!doc) return

  // Temporarily open all collapsed <details> so innerText captures everything
  const closed = doc.querySelectorAll('details:not([open])')
  closed.forEach(d => d.setAttribute('open', ''))

  const content = doc.innerText
  await navigator.clipboard.writeText(content)

  // Restore collapsed state
  closed.forEach(d => d.removeAttribute('open'))

  copied.value = true
  setTimeout(() => { copied.value = false }, 2000)
}
</script>

<template>
  <!-- Library overview page: PackageName › LibraryName -->
  <div v-if="isLibraryOverview && libraryDirName" class="api-breadcrumb">
    <div class="breadcrumb-trail">
      <a :href="withBase('/api/')" class="breadcrumb-link">{{ packageName }}</a>
      <span class="breadcrumb-separator">›</span>
      <span class="breadcrumb-current">{{ libraryDisplayName }}</span>
    </div>
    <div class="breadcrumb-actions">
      <button class="action-btn" :title="copied ? 'Copied!' : 'Copy page'" @click="copyPage">
        <svg v-if="!copied" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
        <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
      </button>
      <a v-if="sourceUrl" :href="sourceUrl" target="_blank" rel="noopener" class="action-btn" title="View source">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
      </a>
    </div>
  </div>

  <!-- Element page: PackageName › LibraryName › Category › ElementTitle -->
  <div v-else-if="libraryDirName && category" class="api-breadcrumb">
    <div class="breadcrumb-trail">
      <a :href="withBase(`/api/${libraryDirName}/`)" class="breadcrumb-link">{{ libraryDisplayName }}</a>
      <span class="breadcrumb-separator">›</span>
      <span class="breadcrumb-category">{{ category }}</span>
      <template v-if="pageTitle">
        <span class="breadcrumb-separator">›</span>
        <span class="breadcrumb-current">{{ pageTitle }}</span>
      </template>
    </div>
    <div class="breadcrumb-actions">
      <button class="action-btn" :title="copied ? 'Copied!' : 'Copy page'" @click="copyPage">
        <svg v-if="!copied" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
        <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
      </button>
      <a v-if="sourceUrl" :href="sourceUrl" target="_blank" rel="noopener" class="action-btn" title="View source">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
      </a>
    </div>
  </div>

  <!-- Non-API pages (guides, etc.): just the copy button -->
  <div v-else-if="!isHomePage" class="api-breadcrumb">
    <div class="breadcrumb-trail"></div>
    <div class="breadcrumb-actions">
      <button class="action-btn" :title="copied ? 'Copied!' : 'Copy page'" @click="copyPage">
        <svg v-if="!copied" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
        <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
      </button>
    </div>
  </div>
</template>

<style scoped>
.api-breadcrumb {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 0.85em;
  margin-bottom: 0.5em;
  color: var(--vp-c-text-3);
  line-height: 1.5;
}

.breadcrumb-trail {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0;
}

.breadcrumb-link {
  color: var(--vp-c-brand-1);
  text-decoration: none;
  transition: color 0.2s;
}

.breadcrumb-link:hover {
  color: var(--vp-c-brand-2);
  text-decoration: underline;
}

.breadcrumb-separator {
  margin: 0 0.4em;
  color: var(--vp-c-text-3);
}

.breadcrumb-category {
  color: var(--vp-c-text-2);
}

.breadcrumb-current {
  color: var(--vp-c-text-1);
}

.breadcrumb-actions {
  display: flex;
  align-items: center;
  gap: 2px;
  flex-shrink: 0;
}

.action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--vp-c-text-3);
  padding: 6px;
  border: none;
  background: none;
  border-radius: 6px;
  cursor: pointer;
  transition: color 0.2s, background-color 0.2s;
}

.action-btn:hover {
  color: var(--vp-c-brand-1);
  background-color: var(--vp-c-bg-soft);
}
</style>
