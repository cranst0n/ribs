/**
 * Orchestrates the split VitePress build.
 *
 * With 1400+ API pages, a single Rollup build exhausts available RAM.
 * This script builds one section at a time:
 *   1. The guide section (guide pages + api/index.md landing page)
 *   2. Each API package directory, discovered automatically from api/
 *
 * Each partial build is merged into dist/ and cleaned up immediately, so
 * disk usage stays low. The merged site works because each HTML page loads
 * its own hashed app.js; cross-section navigation falls back to a full page
 * reload (VitePress's default behaviour for unknown routes).
 *
 * To add a new package: regenerate api/ with `melos run doc`, then run
 * `melos run website-build` — no changes to this file or config.ts needed.
 */

import { readdirSync, cpSync, rmSync, existsSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'
import { execSync } from 'node:child_process'

const __dirname = dirname(fileURLToPath(import.meta.url))
const root    = resolve(__dirname, '..')        // website/vitepress-site/
const apiDir  = resolve(root, 'api')
const distDir = resolve(__dirname, 'dist')      // .vitepress/dist/
const tmpOut  = '.vitepress/dist-pkg'           // reused for each package build
const tmpAbs  = resolve(root, tmpOut)

const NODE_OPTIONS = '--max-old-space-size=5120'

function vitepress(section, outDir) {
  const args = ['vitepress', 'build', ...(outDir ? ['--outDir', outDir] : [])]
  execSync(`npx ${args.join(' ')}`, {
    stdio: 'inherit',
    cwd: root,
    env: { ...process.env, VITE_SECTION: section, NODE_OPTIONS },
  })
}

// Discover API packages from the filesystem — no hardcoded list.
const packages = existsSync(apiDir)
  ? readdirSync(apiDir, { withFileTypes: true })
      .filter(d => d.isDirectory())
      .map(d => d.name)
      .sort()
  : []

console.log(`Discovered ${packages.length} API packages:\n  ${packages.join('\n  ')}\n`)

// ── 1. Guide section ────────────────────────────────────────────────────────
// Outputs to .vitepress/dist/ (the primary output directory).
// Also includes api/index.md (the API landing page).
console.log('=== guide ===')
vitepress('guide')

// ── 2. API packages ─────────────────────────────────────────────────────────
// Each package is built into dist-pkg/, merged into dist/, then cleaned up.
for (const pkg of packages) {
  console.log(`\n=== ${pkg} ===`)
  vitepress(pkg, tmpOut)

  cpSync(resolve(tmpAbs, 'api'),    resolve(distDir, 'api'),    { recursive: true })
  cpSync(resolve(tmpAbs, 'assets'), resolve(distDir, 'assets'), { recursive: true })
  rmSync(tmpAbs, { recursive: true, force: true })
}

console.log('\n=== build complete ===')
