import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.BolAXzrN.js";
const __pageData = JSON.parse('{"title":"Tuple7WriteOps<A, B, C, D, E, F, G>","description":"API documentation for Tuple7WriteOps<A, B, C, D, E, F, G> extension from ribs_sql","frontmatter":{"title":"Tuple7WriteOps<A, B, C, D, E, F, G>","description":"API documentation for Tuple7WriteOps<A, B, C, D, E, F, G> extension from ribs_sql","category":"Extensions","library":"ribs_sql","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sql_ribs_sql/Tuple7WriteOps.md","filePath":"api/package-ribs_sql_ribs_sql/Tuple7WriteOps.md"}');
const _sfc_main = { name: "api/package-ribs_sql_ribs_sql/Tuple7WriteOps.md" };
const _hoisted_1 = {
  id: "prop-tupled",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[4] || (_cache[4] = createStaticVNode('<h1 id="tuple7writeops-a-b-c-d-e-f-g" tabindex="-1">Tuple7WriteOps&lt;A, B, C, D, E, F, G&gt; <a class="header-anchor" href="#tuple7writeops-a-b-c-d-e-f-g" aria-label="Permalink to &quot;Tuple7WriteOps\\&lt;A, B, C, D, E, F, G\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">Tuple7WriteOps</span>&lt;A, B, C, D, E, F, G&gt; <span class="kw">on</span> <span class="type">Record</span></code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 3)),
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
    _cache[5] || (_cache[5] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Write" class="type-link">Write</a>&lt;<span class="type">Record</span>&gt; <span class="kw">get</span> <span class="fn">tupled</span></code></pre></div><p><em>Available on Record, provided by the <a href="/ribs/api/package-ribs_sql_ribs_sql/Tuple7WriteOps.html">Tuple7WriteOps&lt;A, B, C, D, E, F, G&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">C</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">D</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">F</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">G</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> tupled {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> initWrite </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> init.tupled;</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">instance</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(initWrite.puts.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">concat</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(last.puts), (params, n, tuple) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> stmtParams </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> initWrite.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">setParameter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(params, n, tuple.init);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> last.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">setParameter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(stmtParams, n </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> initWrite.length, tuple.last);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  });</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 3))
  ]);
}
const Tuple7WriteOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Tuple7WriteOps as default
};
