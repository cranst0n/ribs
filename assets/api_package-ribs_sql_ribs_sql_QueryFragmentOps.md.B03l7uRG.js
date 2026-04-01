import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.C1WQ-aPd.js";
const __pageData = JSON.parse('{"title":"QueryFragmentOps","description":"API documentation for QueryFragmentOps extension from ribs_sql","frontmatter":{"title":"QueryFragmentOps","description":"API documentation for QueryFragmentOps extension from ribs_sql","category":"Extensions","library":"ribs_sql","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sql_ribs_sql/QueryFragmentOps.md","filePath":"api/package-ribs_sql_ribs_sql/QueryFragmentOps.md"}');
const _sfc_main = { name: "api/package-ribs_sql_ribs_sql/QueryFragmentOps.md" };
const _hoisted_1 = {
  id: "query",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="queryfragmentops" tabindex="-1">QueryFragmentOps <a class="header-anchor" href="#queryfragmentops" aria-label="Permalink to &quot;QueryFragmentOps&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">QueryFragmentOps</span> <span class="kw">on</span> <a href="./Fragment" class="type-link">Fragment</a></code></pre></div><p>Extension to construct a <a href="/ribs/api/package-ribs_sql_ribs_sql/Query.html">Query</a> from a <a href="/ribs/api/package-ribs_sql_ribs_sql/Fragment.html">Fragment</a>.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("query() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#query",
        "aria-label": 'Permalink to "query() <Badge type="info" text="extension" /> {#query}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Query" class="type-link">Query</a>&lt;<span class="type">A</span>&gt; <span class="fn">query&lt;A&gt;</span>(<a href="./Read" class="type-link">Read</a>&lt;<span class="type">A</span>&gt; <span class="param">read</span>)</code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_sql_ribs_sql/Fragment.html">Fragment</a>, provided by the <a href="/ribs/api/package-ribs_sql_ribs_sql/QueryFragmentOps.html">QueryFragmentOps</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Query</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">query</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; read) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Query</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, read);</span></span></code></pre></div></details>', 3))
  ]);
}
const QueryFragmentOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  QueryFragmentOps as default
};
