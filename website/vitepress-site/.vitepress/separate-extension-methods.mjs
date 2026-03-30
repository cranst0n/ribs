#!/usr/bin/env node
// Post-processes dartdoc_vitepress-generated API markdown files to move extension
// methods out of the main Methods section and into a separate Extension Methods
// section. Run after `dart pub global run dartdoc_vitepress ...`.

import { readdir, readFile, writeFile } from 'fs/promises'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const API_DIR = join(__dirname, '..', 'api')

const EXTENSION_BADGE = '<Badge type="info" text="extension" />'
// Categories that can have extension methods mixed into their own methods.
// "Extensions" is excluded — those pages ARE extensions, so all methods are extension methods.
const PROCESS_CATEGORIES = new Set(['"Classes"', '"Mixins"', '"Enums"'])

/**
 * Split a markdown body into H2 sections.
 * Returns { preH2, sections } where each section is { heading, body }.
 * `heading` is the full `## Foo {#id}\n` line.
 * `body` is everything after the heading up to (not including) the next heading.
 */
function splitH2(content) {
  const matches = [...content.matchAll(/^## .+\n/gm)]
  if (matches.length === 0) return { preH2: content, sections: [] }

  const preH2 = content.slice(0, matches[0].index)
  const sections = matches.map((m, i) => {
    const start = m.index
    const end = i + 1 < matches.length ? matches[i + 1].index : content.length
    return {
      heading: m[0],
      body: content.slice(start + m[0].length, end),
    }
  })
  return { preH2, sections }
}

/**
 * Split an H2 section body into H3 blocks.
 * Returns { preH3, blocks } where each block is { heading, body }.
 */
function splitH3(body) {
  const matches = [...body.matchAll(/^### .+\n/gm)]
  if (matches.length === 0) return { preH3: body, blocks: [] }

  const preH3 = body.slice(0, matches[0].index)
  const blocks = matches.map((m, i) => {
    const start = m.index
    const end = i + 1 < matches.length ? matches[i + 1].index : body.length
    return {
      heading: m[0],
      body: body.slice(start + m[0].length, end),
    }
  })
  return { preH3, blocks }
}

/**
 * Given an H2 heading like `## Methods {#section-methods}\n`,
 * return the heading for its extension counterpart.
 */
function extensionHeading(heading) {
  // Insert "Extension " before the title and prefix the id with "extension-"
  return heading.replace(/^## (.+) \{#(.+)\}\n$/, (_, title, id) =>
    `## Extension ${title} {#extension-${id}}\n`
  )
}

async function processFile(filePath) {
  const content = await readFile(filePath, 'utf-8')

  // Quick bail-outs
  if (!content.includes(EXTENSION_BADGE)) return false
  if (content.includes('{#extension-section-')) return false // already processed

  // Check frontmatter category
  const fmEnd = content.indexOf('\n---\n', 4)
  if (fmEnd === -1) return false
  const frontmatter = content.slice(0, fmEnd + 5) // includes trailing "---\n"

  const categoryMatch = frontmatter.match(/^category: (.+)$/m)
  if (!categoryMatch || !PROCESS_CATEGORIES.has(categoryMatch[1].trim())) return false

  const body = content.slice(frontmatter.length)
  const { preH2, sections } = splitH2(body)

  let modified = false
  const newSections = []

  for (const section of sections) {
    if (!section.body.includes(EXTENSION_BADGE)) {
      newSections.push(section)
      continue
    }

    const { preH3, blocks } = splitH3(section.body)
    const regular = blocks.filter(b => !b.heading.includes(EXTENSION_BADGE))
    const extension = blocks.filter(b => b.heading.includes(EXTENSION_BADGE))

    if (extension.length === 0) {
      newSections.push(section)
      continue
    }

    modified = true

    if (regular.length === 0) {
      // All methods in this section are extension methods — just rename the section.
      newSections.push({
        heading: extensionHeading(section.heading),
        body: section.body,
      })
    } else {
      // Split into two sections.
      const regularBody = preH3 + regular.map(b => b.heading + b.body).join('')
      newSections.push({ heading: section.heading, body: regularBody })

      const extBody = preH3 + extension.map(b => b.heading + b.body).join('')
      newSections.push({
        heading: extensionHeading(section.heading),
        body: extBody,
      })
    }
  }

  if (!modified) return false

  const newBody = preH2 + newSections.map(s => s.heading + s.body).join('')
  await writeFile(filePath, frontmatter + newBody)
  return true
}

async function collectMdFiles(dir) {
  const entries = await readdir(dir, { withFileTypes: true })
  const files = []
  for (const entry of entries) {
    const p = join(dir, entry.name)
    if (entry.isDirectory()) {
      files.push(...await collectMdFiles(p))
    } else if (entry.name.endsWith('.md')) {
      files.push(p)
    }
  }
  return files
}

const files = await collectMdFiles(API_DIR)
let count = 0
for (const f of files) {
  if (await processFile(f)) count++
}
console.log(`separate-extension-methods: processed ${count} file(s)`)
