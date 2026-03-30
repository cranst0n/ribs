import { defineConfig } from 'vitepress'
import fs from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { apiSidebar } from './generated/api-sidebar'
import { dartpadPlugin } from './theme/plugins/dartpad'
import { apiLinkerPlugin } from './theme/plugins/api-linker'
// import llmstxt from 'vitepress-plugin-llms'

// ---------------------------------------------------------------------------
// Split-build support
//
// 1400+ API pages exceed available RAM when Rollup processes them all at once.
// build-all.mjs drives the full build by setting VITE_SECTION for each pass:
//   guide              — guide pages + api/index.md only
//   <package-dir-name> — a single API package (e.g. package-ribs_core_ribs_core)
//   (unset)            — full build; only viable in dev (will OOM on prod builds)
//
// No manual edits are needed when adding a new package: build-all.mjs discovers
// packages from the api/ directory at build time, and this config dynamically
// computes the srcExclude from the same directory.
// ---------------------------------------------------------------------------
const __dirname = dirname(fileURLToPath(import.meta.url))
const SECTION = process.env.VITE_SECTION ?? ''

/** Returns all package subdirectory names under api/. */
function getApiPackages(): string[] {
  const apiDir = resolve(__dirname, '../api')
  if (!fs.existsSync(apiDir)) return []
  return fs.readdirSync(apiDir, { withFileTypes: true })
    .filter(d => d.isDirectory())
    .map(d => d.name)
    .sort()
}

function computeSrcExclude(): string[] {
  const base = ['CLAUDE.md', 'AGENTS.md']
  if (!SECTION) return base  // dev: full build

  const allPkgs = getApiPackages()

  if (SECTION === 'guide') {
    // Keep api/index.md (the API landing page); exclude all package subdirs.
    return [...base, ...allPkgs.map(p => `api/${p}/**`)]
  }

  // SECTION is a specific package dir name. Exclude every other package.
  const excludePkgs = allPkgs.filter(p => p !== SECTION)
  return [
    ...base,
    'guide/**',
    'index.md',
    'api/index.md',
    ...excludePkgs.map(p => `api/${p}/**`),
  ]
}

const guideSidebar = {
  '/guide/': [
    { text: 'Overview', link: '/guide/overview' },
    { text: 'Acknowledgements', link: '/guide/acknowledgements' },
    { text: 'Motivation', link: '/guide/motivation' },
    { text: 'Benchmarks', link: '/guide/benchmarks/benchmarks' },
    {
      text: 'Core',
      collapsed: true,
      items: [
        { text: 'Functions', link: '/guide/core/functions' },
        { text: 'Option', link: '/guide/core/option' },
        { text: 'Either', link: '/guide/core/either' },
        { text: 'Validated', link: '/guide/core/validated' },
        { text: 'State', link: '/guide/core/state' },
        { text: 'Unit', link: '/guide/core/unit' },
        {
          text: 'Collections',
          collapsed: true,
          items: [
            { text: 'Overview', link: '/guide/core/collections/overview' },
            { text: 'Sequences', link: '/guide/core/collections/sequence' },
            { text: 'Sets', link: '/guide/core/collections/set' },
            { text: 'Maps', link: '/guide/core/collections/map' },
          ],
        },
        { text: 'Syntax Extensions', link: '/guide/core/syntax' },
      ],
    },
    {
      text: 'Effect',
      collapsed: true,
      items: [
        { text: 'Overview', link: '/guide/effect/overview' },
        { text: 'IO', link: '/guide/effect/io' },
        { text: 'Resource', link: '/guide/effect/resource' },
        { text: 'Ref', link: '/guide/effect/ref' },
        { text: 'Queue', link: '/guide/effect/queue' },
        { text: 'Deferred', link: '/guide/effect/deferred' },
        { text: 'Semaphore', link: '/guide/effect/semaphore' },
        { text: 'Count Down Latch', link: '/guide/effect/count-down-latch' },
        { text: 'Cyclic Barrier', link: '/guide/effect/cyclic-barrier' },
        { text: 'IO Retry', link: '/guide/effect/io-retry' },
        { text: 'Supervisor', link: '/guide/effect/supervisor' },
        { text: 'Dispatcher', link: '/guide/effect/dispatcher' },
        { text: 'Tracing', link: '/guide/effect/tracing' },
        { text: 'Testing', link: '/guide/effect/testing' },
      ],
    },
    {
      text: 'Rill',
      collapsed: true,
      items: [
        { text: 'ARill', link: '/guide/rill/arill' },
        { text: 'Chunk', link: '/guide/rill/chunk' },
        { text: 'Pull', link: '/guide/rill/pull' },
        { text: 'Pipe', link: '/guide/rill/pipe' },
        { text: 'Channel', link: '/guide/rill/channel' },
        { text: 'Topic', link: '/guide/rill/topic' },
        { text: 'Signal', link: '/guide/rill/signal' },
        { text: 'Rill IO', link: '/guide/rill/rill_io' },
      ],
    },
    {
      text: 'JSON',
      collapsed: true,
      items: [
        { text: 'Parsing JSON', link: '/guide/json/parsing-json' },
        { text: 'Creating JSON', link: '/guide/json/creating-json' },
        { text: 'Encoding & Decoding', link: '/guide/json/encoding-and-decoding' },
        { text: 'Streaming', link: '/guide/json/streaming' },
      ],
    },
    {
      text: 'Binary',
      collapsed: true,
      items: [
        { text: 'Bit & Byte Vectors', link: '/guide/binary/bit-byte-vector' },
        { text: 'Encoding & Decoding', link: '/guide/binary/encoding-and-decoding' },
        { text: 'Streaming', link: '/guide/binary/streaming' },
        { text: 'CRC', link: '/guide/binary/crc' },
      ],
    },
    {
      text: 'Check',
      collapsed: true,
      items: [
        { text: 'Property-Based Testing', link: '/guide/check/property-based-testing' },
      ],
    },
    {
      text: 'SQL',
      collapsed: true,
      items: [
        { text: 'Overview', link: '/guide/sql/overview' },
        { text: 'SQLite', link: '/guide/sql/sqlite' },
        { text: 'Postgres', link: '/guide/sql/postgres' },
      ],
    },
    {
      text: 'Units',
      collapsed: true,
      items: [
        { text: 'Motivation', link: '/guide/units/motivation' },
        { text: 'Quantities', link: '/guide/units/quantities' },
      ],
    },
    {
      text: 'Optics',
      collapsed: true,
      items: [
        { text: 'Overview', link: '/guide/optics/overview' },
        { text: 'Lens', link: '/guide/optics/lens' },
        { text: 'Prism', link: '/guide/optics/prism' },
        { text: 'Iso', link: '/guide/optics/iso' },
        { text: 'Optional', link: '/guide/optics/optional' },
      ],
    },
  ],
}

export default defineConfig({
  title: 'Ribs',
  description: 'First-class functional programming for Dart',
  appearance: 'dark',
  head: [['link', { rel: 'icon', href: '/logo.png', type: 'image/png' }]],
  srcExclude: computeSrcExclude(),
  ignoreDeadLinks: true,
  metaChunk: true, // Extract metadata into a shared chunk to reduce per-page JS weight.
  // Disabled: git log bloats child-process memory.
  lastUpdated: false,
  // Limit concurrent page renders to reduce peak memory usage.
  buildConcurrency: 8,
  vite: {
    ssr: {
      noExternal: ['mark.js'],
    },
    build: {
      // Disable sourcemaps and minification to reduce peak memory during Rollup bundling.
      sourcemap: false,
      minify: false,
      rollupOptions: {
        cache: false,
        // Skip tree-shaking analysis — saves significant memory on 1400+ page module graphs.
        treeshake: false,
        maxParallelFileOps: 10,
        output: {
          // VitePress's default manualChunks splits into 'theme' and 'framework'
          // but their mutual imports create a circular chunk dependency (CIRCULAR_CHUNK).
          // Setting undefined doesn't override VitePress's function — Vite's config
          // merge ignores undefined values. Providing an explicit function that
          // assigns both to a single 'vendor' chunk resolves the cycle.
          manualChunks(id) {
            if (
              id.startsWith('\0vite') ||
              id.includes('plugin-vue:export-helper') ||
              id.includes('/vitepress/') ||
              id.includes('/@vue/')
            ) {
              return 'vendor'
            }
          },
        },
      },
    },
  },
  markdown: {
    config: (md) => {
      md.use(dartpadPlugin)
      md.use(apiLinkerPlugin)
    },
  },
  themeConfig: {
    logo: { src: '/logo.png', width: 36, height: 36, alt: 'Ribs' },
    // "On this page" outline: h2–h3 only (h4 depth adds overhead across 1400+ pages).
    outline: { level: [2, 3] },
    // Full-text search powered by MiniSearch (built into VitePress).
    search: {
      provider: 'local',
    },
    // Navigation bar links.
    nav: [
      { text: 'Guide', link: '/guide/overview' },
      { text: 'API Reference', link: '/api/' },
    ],
    sidebar: {
      ...apiSidebar,
      ...guideSidebar,
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/cranst0n/ribs' },
    ],
  },
})
