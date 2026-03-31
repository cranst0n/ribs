import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.B83uV5Lw.js";
const __pageData = JSON.parse('{"title":"RillChunkOps","description":"API documentation for RillChunkOps<A> extension from ribs_rill","frontmatter":{"title":"RillChunkOps<A>","description":"API documentation for RillChunkOps<A> extension from ribs_rill","category":"Extensions","library":"ribs_rill","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_rill_ribs_rill/RillChunkOps.md","filePath":"api/package-ribs_rill_ribs_rill/RillChunkOps.md"}');
const _sfc_main = { name: "api/package-ribs_rill_ribs_rill/RillChunkOps.md" };
const _hoisted_1 = {
  id: "prop-unchunks",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[4] || (_cache[4] = createStaticVNode('<h1 id="rillchunkops-a" tabindex="-1">RillChunkOps&lt;A&gt; <a class="header-anchor" href="#rillchunkops-a" aria-label="Permalink to &quot;RillChunkOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">RillChunkOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./Rill" class="type-link">Rill</a>&lt;<a href="./Chunk" class="type-link">Chunk</a>&lt;<span class="type">A</span>&gt;&gt;</code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("unchunks ", -1)),
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
        href: "#prop-unchunks",
        "aria-label": 'Permalink to "unchunks <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-unchunks}"'
      }, "​", -1))
    ]),
    _cache[5] || (_cache[5] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Rill" class="type-link">Rill</a>&lt;<span class="type">A</span>&gt; <span class="kw">get</span> <span class="fn">unchunks</span></code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_rill_ribs_rill/Rill.html">Rill&lt;O&gt;</a>, provided by the <a href="/ribs/api/package-ribs_rill_ribs_rill/RillChunkOps.html">RillChunkOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Rill</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> unchunks </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> underlying.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatMapOutput</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((c) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Pull</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">output</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(c)).rillNoScope;</span></span></code></pre></div></details>', 3))
  ]);
}
const RillChunkOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  RillChunkOps as default
};
