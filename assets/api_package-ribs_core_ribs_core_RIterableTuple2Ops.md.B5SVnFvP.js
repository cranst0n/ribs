import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.hvR2mfTX.js";
const __pageData = JSON.parse('{"title":"RIterableTuple2Ops<A, B>","description":"API documentation for RIterableTuple2Ops<A, B> extension from ribs_core","frontmatter":{"title":"RIterableTuple2Ops<A, B>","description":"API documentation for RIterableTuple2Ops<A, B> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/RIterableTuple2Ops.md","filePath":"api/package-ribs_core_ribs_core/RIterableTuple2Ops.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/RIterableTuple2Ops.md" };
const _hoisted_1 = {
  id: "toimap",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="riterabletuple2ops-a-b" tabindex="-1">RIterableTuple2Ops&lt;A, B&gt; <a class="header-anchor" href="#riterabletuple2ops-a-b" aria-label="Permalink to &quot;RIterableTuple2Ops\\&lt;A, B\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">RIterableTuple2Ops</span>&lt;A, B&gt; <span class="kw">on</span> <a href="./RIterable" class="type-link">RIterable</a>&lt;<span class="type">Record</span>&gt;</code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("toIMap() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#toimap",
        "aria-label": 'Permalink to "toIMap() <Badge type="info" text="extension" /> {#toimap}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IMap" class="type-link">IMap</a>&lt;<span class="type">A</span>, <span class="type">B</span>&gt; <span class="fn">toIMap</span>()</code></pre></div><p>Creates a new <a href="/ribs/api/package-ribs_core_ribs_core/IMap.html">IMap</a> where element tuple element of this list is used to create a key and value respectively.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/RIterable.html">RIterable&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/RIterableTuple2Ops.html">RIterableTuple2Ops&lt;A, B&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toIMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">from</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4))
  ]);
}
const RIterableTuple2Ops = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  RIterableTuple2Ops as default
};
