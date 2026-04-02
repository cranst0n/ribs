import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.Dhs2tkP8.js";
const __pageData = JSON.parse('{"title":"ILazyListNestedOps","description":"API documentation for ILazyListNestedOps<A> extension from ribs_core","frontmatter":{"title":"ILazyListNestedOps<A>","description":"API documentation for ILazyListNestedOps<A> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/ILazyListNestedOps.md","filePath":"api/package-ribs_core_ribs_core/ILazyListNestedOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/ILazyListNestedOps.md" };
const _hoisted_1 = {
  id: "flatten",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="ilazylistnestedops-a" tabindex="-1">ILazyListNestedOps&lt;A&gt; <a class="header-anchor" href="#ilazylistnestedops-a" aria-label="Permalink to &quot;ILazyListNestedOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">ILazyListNestedOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./ILazyList" class="type-link">ILazyList</a>&lt;<a href="./ILazyList" class="type-link">ILazyList</a>&lt;<span class="type">A</span>&gt;&gt;</code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("flatten() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#flatten",
        "aria-label": 'Permalink to "flatten() <Badge type="info" text="extension" /> {#flatten}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./ILazyList" class="type-link">ILazyList</a>&lt;<span class="type">A</span>&gt; <span class="fn">flatten</span>()</code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/ILazyList.html">ILazyList&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/ILazyListNestedOps.html">ILazyListNestedOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ILazyList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatten</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> flatMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(identity);</span></span></code></pre></div></details>', 3))
  ]);
}
const ILazyListNestedOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  ILazyListNestedOps as default
};
