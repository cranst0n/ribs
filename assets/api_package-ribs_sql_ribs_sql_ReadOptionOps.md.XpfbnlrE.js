import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.BGntlKdh.js";
const __pageData = JSON.parse('{"title":"ReadOptionOps","description":"API documentation for ReadOptionOps<A> extension from ribs_sql","frontmatter":{"title":"ReadOptionOps<A>","description":"API documentation for ReadOptionOps<A> extension from ribs_sql","category":"Extensions","library":"ribs_sql","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sql_ribs_sql/ReadOptionOps.md","filePath":"api/package-ribs_sql_ribs_sql/ReadOptionOps.md"}');
const _sfc_main = { name: "api/package-ribs_sql_ribs_sql/ReadOptionOps.md" };
const _hoisted_1 = {
  id: "optional",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="readoptionops-a" tabindex="-1">ReadOptionOps&lt;A&gt; <a class="header-anchor" href="#readoptionops-a" aria-label="Permalink to &quot;ReadOptionOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">ReadOptionOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./Read" class="type-link">Read</a>&lt;<span class="type">A</span>&gt;</code></pre></div><p>Adds nullable column support to <a href="/ribs/api/package-ribs_sql_ribs_sql/Read.html">Read</a>.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("optional() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#optional",
        "aria-label": 'Permalink to "optional() <Badge type="info" text="extension" /> {#optional}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Read" class="type-link">Read</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">optional</span>()</code></pre></div><p>Returns a <a href="/ribs/api/package-ribs_sql_ribs_sql/Read.html">Read</a> that produces <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> when the column is <code>null</code> or out of range, and <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> with the decoded value otherwise.</p><p><em>Available on <a href="/ribs/api/package-ribs_sql_ribs_sql/Read.html">Read&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadOptionOps.html">ReadOptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">optional</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">instance</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  gets,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (row, n) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unless</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> n </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> row.length </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">||</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> row[n] </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> null</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> unsafeGet</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(row, n),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4))
  ]);
}
const ReadOptionOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  ReadOptionOps as default
};
