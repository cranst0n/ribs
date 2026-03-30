import type MarkdownIt from 'markdown-it'

/**
 * markdown-it plugin that transforms ```dartpad code fences into
 * <DartPad> Vue components with base64-encoded code prop.
 *
 * Supports optional meta attributes:
 *   ```dartpad height=500 run=false mode=flutter
 */
export function dartpadPlugin(md: MarkdownIt) {
  const defaultFence = md.renderer.rules.fence!.bind(md.renderer.rules)

  md.renderer.rules.fence = (tokens, idx, options, env, self) => {
    const token = tokens[idx]
    const info = token.info.trim()

    if (!info.startsWith('dartpad')) {
      return defaultFence(tokens, idx, options, env, self)
    }

    const code = token.content
    const encoded = Buffer.from(code).toString('base64')

    // Parse optional attributes: height=500 run=false mode=flutter
    const meta = info.slice('dartpad'.length).trim()
    const attrs: string[] = [`code="${encoded}"`]

    const heightMatch = meta.match(/\bheight=(\d+)/)
    if (heightMatch) attrs.push(`:height="${heightMatch[1]}"`)

    const runMatch = meta.match(/\brun=(true|false)/)
    if (runMatch) attrs.push(`:run="${runMatch[1]}"`)

    const modeMatch = meta.match(/\bmode=(dart|flutter)/)
    if (modeMatch) attrs.push(`mode="${modeMatch[1]}"`)

    // Render syntax-highlighted code via VitePress Shiki pipeline.
    // Temporarily set token info to 'dart' so the default fence
    // renderer applies Dart syntax highlighting, then restore it.
    const originalInfo = token.info
    token.info = 'dart'
    const highlightedHtml = defaultFence(tokens, idx, options, env, self)
    token.info = originalInfo

    return `<DartPad ${attrs.join(' ')}>${highlightedHtml}</DartPad>\n`
  }
}
