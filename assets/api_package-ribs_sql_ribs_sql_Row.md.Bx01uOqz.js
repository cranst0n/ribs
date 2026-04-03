import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.DGv_OU7R.js";
const __pageData = JSON.parse('{"title":"Row","description":"API documentation for Row extension type from ribs_sql","frontmatter":{"title":"Row","description":"API documentation for Row extension type from ribs_sql","category":"Extension Types","library":"ribs_sql","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sql_ribs_sql/Row.md","filePath":"api/package-ribs_sql_ribs_sql/Row.md"}');
const _sfc_main = { name: "api/package-ribs_sql_ribs_sql/Row.md" };
const _hoisted_1 = {
  id: "prop-length",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="row" tabindex="-1">Row <a class="header-anchor" href="#row" aria-label="Permalink to &quot;Row&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension type</span> <span class="fn">Row</span>(<a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<span class="type">Object</span>?&gt;)</code></pre></div><p>Alias type for <a href="../package-ribs_core_ribs_core/IList.html" class="api-link"><code>IList&lt;Object?&gt;</code></a> used to abstract row types used by different database drivers.</p><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-row" tabindex="-1">Row() <a class="header-anchor" href="#ctor-row" aria-label="Permalink to &quot;Row() {#ctor-row}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">Row</span>(<a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<span class="type">Object</span>?&gt; <span class="param">_columns</span>)</code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 7)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("length ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-length",
        "aria-label": 'Permalink to "length <Badge type="tip" text="no setter" /> {#prop-length}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">length</span></code></pre></div><p>The number of columns in this row.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> length </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _columns.length;</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2><h3 id="operator-get" tabindex="-1">operator <a href="./.html"></a> <a class="header-anchor" href="#operator-get" aria-label="Permalink to &quot;operator []() {#operator-get}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="type">Object</span>? <span class="fn">operator []</span>(<span class="type">int</span> <span class="param">index</span>)</code></pre></div><p>Returns the column value at <code>index</code>, or throws if out of range.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> [](</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> index) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _columns[index];</span></span></code></pre></div></details>', 8))
  ]);
}
const Row = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Row as default
};
