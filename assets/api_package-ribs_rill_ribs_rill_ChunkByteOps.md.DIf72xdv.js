import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.CuyslSU3.js";
const __pageData = JSON.parse('{"title":"ChunkByteOps","description":"API documentation for ChunkByteOps extension from ribs_rill","frontmatter":{"title":"ChunkByteOps","description":"API documentation for ChunkByteOps extension from ribs_rill","category":"Extensions","library":"ribs_rill","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_rill_ribs_rill/ChunkByteOps.md","filePath":"api/package-ribs_rill_ribs_rill/ChunkByteOps.md"}');
const _sfc_main = { name: "api/package-ribs_rill_ribs_rill/ChunkByteOps.md" };
const _hoisted_1 = {
  id: "prop-asuint8list",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-tobitvector",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "prop-tobytevector",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[12] || (_cache[12] = createStaticVNode('<h1 id="chunkbyteops" tabindex="-1">ChunkByteOps <a class="header-anchor" href="#chunkbyteops" aria-label="Permalink to &quot;ChunkByteOps&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">ChunkByteOps</span> <span class="kw">on</span> <a href="./Chunk" class="type-link">Chunk</a>&lt;<span class="type">int</span>&gt;</code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("asUint8List ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[2] || (_cache[2] = createTextVNode()),
      _cache[3] || (_cache[3] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-asuint8list",
        "aria-label": 'Permalink to "asUint8List <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-asuint8list}"'
      }, "​", -1))
    ]),
    _cache[13] || (_cache[13] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Uint8List</span> <span class="kw">get</span> <span class="fn">asUint8List</span></code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_rill_ribs_rill/Chunk.html">Chunk&lt;O&gt;</a>, provided by the <a href="/ribs/api/package-ribs_rill_ribs_rill/ChunkByteOps.html">ChunkByteOps</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Uint8List</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> asUint8List {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> switch</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> _ByteVectorChunk</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> bv </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> bv.asUint8List,</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> _Uint8ListChunk</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ch </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ch.asUint8List,</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> _BoxedChunk</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; boxed </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Uint8List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fromList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(boxed._values),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    _ </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Uint8List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fromList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toDartList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  };</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[4] || (_cache[4] = createTextVNode("toBitVector ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[5] || (_cache[5] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[6] || (_cache[6] = createTextVNode()),
      _cache[7] || (_cache[7] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tobitvector",
        "aria-label": 'Permalink to "toBitVector <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-tobitvector}"'
      }, "​", -1))
    ]),
    _cache[14] || (_cache[14] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_binary_ribs_binary/BitVector" class="type-link">BitVector</a> <span class="kw">get</span> <span class="fn">toBitVector</span></code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_rill_ribs_rill/Chunk.html">Chunk&lt;O&gt;</a>, provided by the <a href="/ribs/api/package-ribs_rill_ribs_rill/ChunkByteOps.html">ChunkByteOps</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">BitVector</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toBitVector </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toByteVector.bits;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[8] || (_cache[8] = createTextVNode("toByteVector ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[9] || (_cache[9] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[10] || (_cache[10] = createTextVNode()),
      _cache[11] || (_cache[11] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tobytevector",
        "aria-label": 'Permalink to "toByteVector <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-tobytevector}"'
      }, "​", -1))
    ]),
    _cache[15] || (_cache[15] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_binary_ribs_binary/ByteVector" class="type-link">ByteVector</a> <span class="kw">get</span> <span class="fn">toByteVector</span></code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_rill_ribs_rill/Chunk.html">Chunk&lt;O&gt;</a>, provided by the <a href="/ribs/api/package-ribs_rill_ribs_rill/ChunkByteOps.html">ChunkByteOps</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ByteVector</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toByteVector </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ByteVector</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">viewAt</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">At</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((i) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">[i]), size);</span></span></code></pre></div></details>', 3))
  ]);
}
const ChunkByteOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  ChunkByteOps as default
};
