import type MarkdownIt from 'markdown-it'
import fs from 'node:fs'
import path from 'node:path'

interface SymbolEntry {
  name: string
  /** Site-root-relative path, e.g. "api/modularity_flutter/ModuleScope.html" */
  targetPath: string
  package: string
}

/**
 * Dart/Flutter built-in types that should never be auto-linked.
 */
const IGNORE = new Set([
  // Dart core
  'String', 'int', 'double', 'bool', 'num', 'dynamic', 'void', 'Object',
  'List', 'Map', 'Set', 'Future', 'Stream', 'Iterable', 'Type',
  'Function', 'Null', 'Never', 'Record', 'Duration', 'DateTime',
  'Uri', 'RegExp', 'Error', 'Exception', 'Completer', 'Timer',
  'StreamController', 'Stopwatch',
  // Generic type params
  'T', 'E', 'K', 'V', 'R', 'S',
  // Flutter widgets & framework
  'Widget', 'BuildContext', 'State', 'StatelessWidget', 'StatefulWidget',
  'Key', 'GlobalKey', 'InheritedWidget', 'InheritedNotifier',
  'Navigator', 'Route', 'ModalRoute', 'RouteObserver', 'PageRoute',
  'MaterialApp', 'Scaffold', 'Text', 'Center', 'Column', 'Row',
  'Container', 'SizedBox', 'Padding', 'ElevatedButton', 'TextButton',
  'CircularProgressIndicator', 'MaterialPageRoute',
])

/**
 * Compute a relative URL from one site path to another.
 * Both paths are relative to the site root (e.g. "guide/getting-started.md").
 */
function relativeUrl(fromPath: string, toPath: string): string {
  const fromDir = fromPath.replace(/[^/]+$/, '')
  const rel = path.posix.relative(fromDir, toPath)
  return rel.startsWith('.') ? rel : './' + rel
}

/**
 * Scan the api/ directory to build a map: ClassName -> SymbolEntry[].
 * When a symbol exists in multiple packages, all entries are kept so the
 * renderer can pick the best match based on page context.
 */
function buildSymbolMap(apiDir: string): Map<string, SymbolEntry[]> {
  const map = new Map<string, SymbolEntry[]>()

  if (!fs.existsSync(apiDir)) return map

  const packages = fs.readdirSync(apiDir, { withFileTypes: true })
    .filter(d => d.isDirectory())
    .sort((a, b) => a.name.localeCompare(b.name))

  for (const pkg of packages) {
    const pkgDir = path.join(apiDir, pkg.name)
    const files = fs.readdirSync(pkgDir)
      .filter(f => f.endsWith('.md') && f !== 'index.md')

    for (const file of files) {
      const name = file.replace('.md', '')
      const targetPath = `api/${pkg.name}/${name}.html`
      const entry: SymbolEntry = { name, targetPath, package: pkg.name }

      const existing = map.get(name)
      if (existing) {
        existing.push(entry)
      } else {
        map.set(name, [entry])
      }
    }
  }

  return map
}

/**
 * Pick the best symbol entry for the current page context.
 * - If the page path contains a package name from the entries, prefer that one.
 * - Otherwise, return the first entry (alphabetically by package name).
 */
function pickEntry(entries: SymbolEntry[], relativePath: string): SymbolEntry {
  if (entries.length === 1) return entries[0]

  for (const entry of entries) {
    if (relativePath.includes(entry.package)) return entry
  }

  // Check for keyword hints in the page path
  for (const entry of entries) {
    const keywords = entry.package.split(/[-_]/)
    if (keywords.some(kw => kw.length > 3 && relativePath.includes(kw))) {
      return entry
    }
  }

  return entries[0]
}

/**
 * markdown-it plugin that auto-links inline code references to API docs.
 *
 * At build time, scans the generated `api/` directory and builds a symbol
 * map. During markdown rendering, transforms `code_inline` tokens like
 * `ModuleScope` into clickable links to the corresponding API page.
 *
 * Handles:
 * - Simple references: `ModuleScope` -> link to /api/pkg/ModuleScope
 * - Dotted access: `Modularity.observer` -> link to /api/pkg/Modularity
 * - Generics: `ModuleScope<Auth>` -> link to /api/pkg/ModuleScope
 * - Skips lowercase: `binder.get<T>()` -> no link (not a class reference)
 * - Skips built-in types: `String`, `Widget`, `BuildContext` etc.
 * - Skips code inside existing links
 * - Skips self-references on API pages
 */
export function apiLinkerPlugin(md: MarkdownIt) {
  const apiDir = path.resolve(__dirname, '../../../api')
  const symbolMap = buildSymbolMap(apiDir)

  const defaultRender = md.renderer.rules.code_inline ||
    function (tokens, idx, options, _env, self) {
      return self.renderToken(tokens, idx, options)
    }

  md.renderer.rules.code_inline = (tokens, idx, options, env, self) => {
    const token = tokens[idx]
    const content = token.content.trim()

    // Skip if already inside a markdown link (link_open ... link_close)
    for (let i = idx - 1; i >= 0; i--) {
      if (tokens[i].type === 'link_open') return defaultRender(tokens, idx, options, env, self)
      if (tokens[i].type === 'link_close' || tokens[i].nesting === -1) break
      if (tokens[i].type === 'text' && tokens[i].content.trim() === '') continue
      break
    }

    // Extract leading PascalCase identifier
    const match = content.match(/^([A-Z][A-Za-z0-9]*)/)
    if (!match) return defaultRender(tokens, idx, options, env, self)

    const className = match[1]

    if (IGNORE.has(className)) return defaultRender(tokens, idx, options, env, self)

    const entries = symbolMap.get(className)
    if (!entries) return defaultRender(tokens, idx, options, env, self)

    // Don't self-link on the symbol's own API page
    const relativePath: string = (env as Record<string, unknown>).relativePath as string || ''
    const entry = pickEntry(entries, relativePath)
    if (relativePath.startsWith(`api/${entry.package}/${className}`)) {
      return defaultRender(tokens, idx, options, env, self)
    }

    const href = relativeUrl(relativePath, entry.targetPath)
    const escaped = md.utils.escapeHtml(content)
    return `<a href="${href}" class="api-link"><code>${escaped}</code></a>`
  }
}
