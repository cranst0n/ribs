import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.DGv_OU7R.js";
const __pageData = JSON.parse('{"title":"Tuple9ReadWriteOps<A, B, C, D, E, F, G, H, I>","description":"API documentation for Tuple9ReadWriteOps<A, B, C, D, E, F, G, H, I> extension from ribs_sql","frontmatter":{"title":"Tuple9ReadWriteOps<A, B, C, D, E, F, G, H, I>","description":"API documentation for Tuple9ReadWriteOps<A, B, C, D, E, F, G, H, I> extension from ribs_sql","category":"Extensions","library":"ribs_sql","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sql_ribs_sql/Tuple9ReadWriteOps.md","filePath":"api/package-ribs_sql_ribs_sql/Tuple9ReadWriteOps.md"}');
const _sfc_main = { name: "api/package-ribs_sql_ribs_sql/Tuple9ReadWriteOps.md" };
const _hoisted_1 = {
  id: "prop-tupled",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[4] || (_cache[4] = createStaticVNode('<h1 id="tuple9readwriteops-a-b-c-d-e-f-g-h-i" tabindex="-1">Tuple9ReadWriteOps&lt;A, B, C, D, E, F, G, H, I&gt; <a class="header-anchor" href="#tuple9readwriteops-a-b-c-d-e-f-g-h-i" aria-label="Permalink to &quot;Tuple9ReadWriteOps\\&lt;A, B, C, D, E, F, G, H, I\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">Tuple9ReadWriteOps</span>&lt;A, B, C, D, E, F, G, H, I&gt; <span class="kw">on</span> <span class="type">Record</span></code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("tupled ", -1)),
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
        href: "#prop-tupled",
        "aria-label": 'Permalink to "tupled <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-tupled}"'
      }, "​", -1))
    ]),
    _cache[5] || (_cache[5] = createStaticVNode('<div class="member-signature"><pre><code><a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">Record</span>&gt; <span class="kw">get</span> <span class="fn">tupled</span></code></pre></div><p><em>Available on Record, provided by the <a href="/ribs/api/package-ribs_sql_ribs_sql/Tuple9ReadWriteOps.html">Tuple9ReadWriteOps&lt;A, B, C, D, E, F, G, H, I&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">C</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">D</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">F</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">G</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">H</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">I</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> tupled </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ($1.read, $2.read, $3.read, $4.read, $5.read, $6.read, $7.read, $8.read, $9.read).tupled,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $1.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $2.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $3.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $4.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $5.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $6.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $7.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $8.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    $9.write,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ).tupled,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 3))
  ]);
}
const Tuple9ReadWriteOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Tuple9ReadWriteOps as default
};
