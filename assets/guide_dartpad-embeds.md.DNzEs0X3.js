import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createVNode, w as withCtx, d as createBaseVNode, e as createTextVNode, _ as _export_sfc } from "./app.DwCz9QeS.js";
const __pageData = JSON.parse('{"title":"DartPad Embeds","description":"","frontmatter":{"sidebar_position":3},"headers":[],"relativePath":"guide/dartpad-embeds.md","filePath":"guide/dartpad-embeds.md"}');
const _sfc_main = { name: "guide/dartpad-embeds.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_DartPad = resolveComponent("DartPad");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="dartpad-embeds" tabindex="-1">DartPad Embeds <a class="header-anchor" href="#dartpad-embeds" aria-label="Permalink to &quot;DartPad Embeds&quot;">​</a></h1><p>dartdoc_modern turns code blocks into interactive <a href="https://dartpad.dev" target="_blank" rel="noreferrer">DartPad</a> playgrounds. Your readers can run and edit Dart code without leaving the docs page.</p><h2 id="syntax" tabindex="-1">Syntax <a class="header-anchor" href="#syntax" aria-label="Permalink to &quot;Syntax&quot;">​</a></h2><p>Use a fenced code block with the <code>dartpad</code> language tag instead of <code>dart</code>:</p><div class="language-markdown vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">markdown</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">```dartpad</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">void main() {</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  print(&#39;Hello from DartPad!&#39;);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">```</span></span></code></pre></div><p>This renders as a syntax-highlighted code block with <strong>Play</strong> and <strong>Copy</strong> buttons. Clicking Play opens an embedded DartPad iframe with the code loaded and ready to run.</p><h2 id="live-example-—-dart" tabindex="-1">Live Example — Dart <a class="header-anchor" href="#live-example-—-dart" aria-label="Permalink to &quot;Live Example — Dart&quot;">​</a></h2>', 7)),
    createVNode(_component_DartPad, { code: "dm9pZCBtYWluKCkgewogIGZpbmFsIGl0ZW1zID0gWydEYXJ0JywgJ0ZsdXR0ZXInLCAnVml0ZVByZXNzJ107CgogIGZvciAoZmluYWwgaXRlbSBpbiBpdGVtcykgewogICAgcHJpbnQoJ2RhcnRkb2NfbW9kZXJuIHN1cHBvcnRzICRpdGVtJyk7CiAgfQoKICAvLyBUcnkgZWRpdGluZyB0aGlzIGNvZGUgYW5kIGNsaWNraW5nIFJ1biEKICBwcmludCgnXG5HZW5lcmF0ZWQgJHtpdGVtcy5sZW5ndGh9IGl0ZW1zJyk7Cn0K" }, {
      default: withCtx(() => [..._cache[0] || (_cache[0] = [
        createBaseVNode("div", { class: "language-dart vp-adaptive-theme" }, [
          createBaseVNode("button", {
            title: "Copy Code",
            class: "copy"
          }),
          createBaseVNode("span", { class: "lang" }, "dart"),
          createBaseVNode("pre", {
            class: "shiki shiki-themes github-light github-dark vp-code",
            tabindex: "0"
          }, [
            createBaseVNode("code", null, [
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "void"),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, " main"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "() {")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "  final"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " items "),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "="),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " ["),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'Dart'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ", "),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'Flutter'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ", "),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'VitePress'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "];")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "  for"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " ("),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "final"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " item "),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "in"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " items) {")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "    print"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'dartdoc_modern supports "),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "$"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "item"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ");")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "  }")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#6A737D", "--shiki-dark": "#6A737D" } }, "  // Try editing this code and clicking Run!")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "  print"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "\\n"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "Generated "),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "${"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "items"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "."),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "length"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "}"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, " items'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ");")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "}")
              ])
            ])
          ])
        ], -1)
      ])]),
      _: 1
    }),
    _cache[4] || (_cache[4] = createStaticVNode('<p>Click the <strong>▶ Play</strong> button above to open the interactive playground.</p><h2 id="attributes" tabindex="-1">Attributes <a class="header-anchor" href="#attributes" aria-label="Permalink to &quot;Attributes&quot;">​</a></h2><p>Add attributes after <code>dartpad</code> to customize behavior:</p><div class="language-markdown vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">markdown</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">```dartpad height=500 mode=flutter run=false</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">// your code</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">```</span></span></code></pre></div><table tabindex="0"><thead><tr><th>Attribute</th><th>Values</th><th>Default</th><th>What it does</th></tr></thead><tbody><tr><td><code>height</code></td><td>any number</td><td><code>400</code></td><td>Iframe height in pixels</td></tr><tr><td><code>mode</code></td><td><code>dart</code>, <code>flutter</code></td><td><code>dart</code></td><td>DartPad mode — pure Dart or Flutter widget</td></tr><tr><td><code>run</code></td><td><code>true</code>, <code>false</code></td><td><code>true</code></td><td>Auto-run code when the playground opens</td></tr></tbody></table><h2 id="flutter-example" tabindex="-1">Flutter Example <a class="header-anchor" href="#flutter-example" aria-label="Permalink to &quot;Flutter Example&quot;">​</a></h2><p>Use <code>mode=flutter</code> for Flutter widgets:</p>', 7)),
    createVNode(_component_DartPad, {
      code: "aW1wb3J0ICdwYWNrYWdlOmZsdXR0ZXIvbWF0ZXJpYWwuZGFydCc7Cgp2b2lkIG1haW4oKSA9PiBydW5BcHAoY29uc3QgTXlBcHAoKSk7CgpjbGFzcyBNeUFwcCBleHRlbmRzIFN0YXRlbGVzc1dpZGdldCB7CiAgY29uc3QgTXlBcHAoe3N1cGVyLmtleX0pOwoKICBAb3ZlcnJpZGUKICBXaWRnZXQgYnVpbGQoQnVpbGRDb250ZXh0IGNvbnRleHQpIHsKICAgIHJldHVybiBNYXRlcmlhbEFwcCgKICAgICAgZGVidWdTaG93Q2hlY2tlZE1vZGVCYW5uZXI6IGZhbHNlLAogICAgICBob21lOiBTY2FmZm9sZCgKICAgICAgICBhcHBCYXI6IEFwcEJhcih0aXRsZTogY29uc3QgVGV4dCgnRGFydFBhZCBpbiBEb2NzJykpLAogICAgICAgIGJvZHk6IENlbnRlcigKICAgICAgICAgIGNoaWxkOiBDb2x1bW4oCiAgICAgICAgICAgIG1haW5BeGlzQWxpZ25tZW50OiBNYWluQXhpc0FsaWdubWVudC5jZW50ZXIsCiAgICAgICAgICAgIGNoaWxkcmVuOiBbCiAgICAgICAgICAgICAgY29uc3QgSWNvbihJY29ucy5hdXRvX3N0b3JpZXMsIHNpemU6IDY0LCBjb2xvcjogQ29sb3JzLmRlZXBQdXJwbGUpLAogICAgICAgICAgICAgIGNvbnN0IFNpemVkQm94KGhlaWdodDogMTYpLAogICAgICAgICAgICAgIFRleHQoCiAgICAgICAgICAgICAgICAnSW50ZXJhY3RpdmUgZG9jcyEnLAogICAgICAgICAgICAgICAgc3R5bGU6IFRoZW1lLm9mKGNvbnRleHQpLnRleHRUaGVtZS5oZWFkbGluZU1lZGl1bSwKICAgICAgICAgICAgICApLAogICAgICAgICAgICAgIGNvbnN0IFNpemVkQm94KGhlaWdodDogOCksCiAgICAgICAgICAgICAgY29uc3QgVGV4dCgnRWRpdCB0aGlzIGNvZGUgYW5kIGhpdCBSdW4nKSwKICAgICAgICAgICAgXSwKICAgICAgICAgICksCiAgICAgICAgKSwKICAgICAgICBmbG9hdGluZ0FjdGlvbkJ1dHRvbjogRmxvYXRpbmdBY3Rpb25CdXR0b24oCiAgICAgICAgICBvblByZXNzZWQ6ICgpIHt9LAogICAgICAgICAgY2hpbGQ6IGNvbnN0IEljb24oSWNvbnMucGxheV9hcnJvdyksCiAgICAgICAgKSwKICAgICAgKSwKICAgICk7CiAgfQp9Cg==",
      height: 500,
      mode: "flutter"
    }, {
      default: withCtx(() => [..._cache[1] || (_cache[1] = [
        createBaseVNode("div", { class: "language-dart vp-adaptive-theme" }, [
          createBaseVNode("button", {
            title: "Copy Code",
            class: "copy"
          }),
          createBaseVNode("span", { class: "lang" }, "dart"),
          createBaseVNode("pre", {
            class: "shiki shiki-themes github-light github-dark vp-code",
            tabindex: "0"
          }, [
            createBaseVNode("code", null, [
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "import"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, " 'package:flutter/material.dart'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ";")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "void"),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, " main"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "() "),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "=>"),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, " runApp"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "const"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " MyApp"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "());")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "class"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " MyApp"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, " extends"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " StatelessWidget"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " {")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "  const"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " MyApp"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "({"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "super"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ".key});")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "  @override")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "  Widget"),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, " build"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "BuildContext"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " context) {")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "    return"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " MaterialApp"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "      debugShowCheckedModeBanner"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " false"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ",")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "      home"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Scaffold"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "        appBar"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " AppBar"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(title"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, " const"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Text"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'DartPad in Docs'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ")),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "        body"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Center"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "          child"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Column"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "            mainAxisAlignment"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " MainAxisAlignment"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ".center,")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "            children"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " [")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "              const"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Icon"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "Icons"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ".auto_stories, size"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " 64"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ", color"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Colors"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ".deepPurple),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "              const"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " SizedBox"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(height"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " 16"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "              Text"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "                'Interactive docs!'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ",")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "                style"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Theme"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "."),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "of"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(context).textTheme.headlineMedium,")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "              ),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "              const"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " SizedBox"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(height"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " 8"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "              const"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Text"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'Edit this code and hit Run'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "            ],")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "          ),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "        ),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "        floatingActionButton"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " FloatingActionButton"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "(")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "          onPressed"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " () {},")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "          child"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, ":"),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, " const"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Icon"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "Icons"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ".play_arrow),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "        ),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "      ),")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "    );")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "  }")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "}")
              ])
            ])
          ])
        ], -1)
      ])]),
      _: 1
    }),
    _cache[5] || (_cache[5] = createBaseVNode("h2", {
      id: "without-auto-run",
      tabindex: "-1"
    }, [
      createTextVNode("Without Auto-Run "),
      createBaseVNode("a", {
        class: "header-anchor",
        href: "#without-auto-run",
        "aria-label": 'Permalink to "Without Auto-Run"'
      }, "​")
    ], -1)),
    _cache[6] || (_cache[6] = createBaseVNode("p", null, [
      createTextVNode("Use "),
      createBaseVNode("code", null, "run=false"),
      createTextVNode(" when the code is long or you want the reader to review it before running:")
    ], -1)),
    createVNode(_component_DartPad, {
      code: "aW1wb3J0ICdkYXJ0Om1hdGgnOwoKdm9pZCBtYWluKCkgewogIGZpbmFsIHJhbmRvbSA9IFJhbmRvbSgpOwogIGZpbmFsIG51bWJlcnMgPSBMaXN0LmdlbmVyYXRlKDEwLCAoXykgPT4gcmFuZG9tLm5leHRJbnQoMTAwKSk7CgogIHByaW50KCdPcmlnaW5hbDogJG51bWJlcnMnKTsKICBudW1iZXJzLnNvcnQoKTsKICBwcmludCgnU29ydGVkOiAgICRudW1iZXJzJyk7CiAgcHJpbnQoJ1N1bTogICAgICAke251bWJlcnMucmVkdWNlKChhLCBiKSA9PiBhICsgYil9Jyk7CiAgcHJpbnQoJ0F2ZXJhZ2U6ICAke251bWJlcnMucmVkdWNlKChhLCBiKSA9PiBhICsgYikgLyBudW1iZXJzLmxlbmd0aH0nKTsKfQo=",
      run: false
    }, {
      default: withCtx(() => [..._cache[2] || (_cache[2] = [
        createBaseVNode("div", { class: "language-dart vp-adaptive-theme" }, [
          createBaseVNode("button", {
            title: "Copy Code",
            class: "copy"
          }),
          createBaseVNode("span", { class: "lang" }, "dart"),
          createBaseVNode("pre", {
            class: "shiki shiki-themes github-light github-dark vp-code",
            tabindex: "0"
          }, [
            createBaseVNode("code", null, [
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "import"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, " 'dart:math'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ";")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "void"),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, " main"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "() {")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "  final"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " random "),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "="),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " Random"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "();")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "  final"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " numbers "),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "="),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, " List"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "."),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "generate"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "10"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ", (_) "),
                createBaseVNode("span", { style: { "--shiki-light": "#D73A49", "--shiki-dark": "#F97583" } }, "=>"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, " random."),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "nextInt"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "100"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "));")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "  print"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'Original: "),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "$"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "numbers"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ");")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "  numbers."),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "sort"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "();")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "  print"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'Sorted:   "),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "$"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "numbers"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ");")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "  print"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'Sum:      "),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "${"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "numbers"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "."),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "reduce"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "(("),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "a"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, ", "),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "b"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, ") => "),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "a"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, " + "),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "b"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, ")}"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ");")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "  print"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "("),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'Average:  "),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "${"),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "numbers"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "."),
                createBaseVNode("span", { style: { "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" } }, "reduce"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "(("),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "a"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, ", "),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "b"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, ") => "),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "a"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, " + "),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "b"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, ") / "),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "numbers"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "."),
                createBaseVNode("span", { style: { "--shiki-light": "#005CC5", "--shiki-dark": "#79B8FF" } }, "length"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "}"),
                createBaseVNode("span", { style: { "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" } }, "'"),
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, ");")
              ]),
              createTextVNode("\n"),
              createBaseVNode("span", { class: "line" }, [
                createBaseVNode("span", { style: { "--shiki-light": "#24292E", "--shiki-dark": "#E1E4E8" } }, "}")
              ])
            ])
          ])
        ], -1)
      ])]),
      _: 1
    }),
    _cache[7] || (_cache[7] = createStaticVNode('<h2 id="how-it-works" tabindex="-1">How It Works <a class="header-anchor" href="#how-it-works" aria-label="Permalink to &quot;How It Works&quot;">​</a></h2><ol><li>The markdown-it plugin (<code>dartpad.ts</code>) detects <code>```dartpad</code> fences</li><li>It base64-encodes the code and emits a <code>&lt;DartPad&gt;</code> Vue component</li><li>The component shows syntax-highlighted code with a toolbar</li><li>On <strong>Play</strong>, it creates an iframe to <code>https://dartpad.dev?embed=true</code></li><li>Once DartPad sends a <code>ready</code> message, the component sends the code via <code>postMessage</code></li><li>Theme (light/dark) syncs automatically with VitePress</li></ol><div class="language-mermaid vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">mermaid</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">sequenceDiagram</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    participant U as User</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    participant V as DartPad.vue&lt;br/&gt;(your docs)</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    participant D as dartpad.dev&lt;br/&gt;(iframe)</span></span>\n<span class="line"></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    U-&gt;&gt;V: Clicks Run</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    V-&gt;&gt;D: Creates iframe&lt;br/&gt;dartpad.dev?embed=true</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    D--&gt;&gt;V: postMessage(&#39;ready&#39;)</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    V-&gt;&gt;D: postMessage(sourceCode)</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    D-&gt;&gt;D: Compiles &amp; runs code</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    D--&gt;&gt;U: Shows output</span></span></code></pre></div><h2 id="security" tabindex="-1">Security <a class="header-anchor" href="#security" aria-label="Permalink to &quot;Security&quot;">​</a></h2><ul><li>Communication uses <code>postMessage</code> with origin checks — only <code>dartpad.dev</code> and <code>dartpad.cn</code> are allowed</li><li>The iframe runs sandboxed: <code>allow-scripts allow-same-origin allow-popups allow-forms</code></li><li>No external scripts are loaded until the user clicks Play</li></ul><h2 id="tips" tabindex="-1">Tips <a class="header-anchor" href="#tips" aria-label="Permalink to &quot;Tips&quot;">​</a></h2><ul><li>Keep examples short and focused — readers should see the output without scrolling</li><li>Use <code>mode=flutter</code> only when demonstrating widgets; plain Dart runs faster</li><li>Add comments like <code>// Try changing this value!</code> to encourage experimentation</li><li><code>run=false</code> is useful for code that has side effects or takes time to execute</li><li>DartPad supports most <code>dart:*</code> libraries and popular pub packages (http, collection, etc.)</li></ul>', 7))
  ]);
}
const dartpadEmbeds = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  dartpadEmbeds as default
};
