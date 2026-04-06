import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.I8Q2zGvD.js";
const __pageData = JSON.parse('{"title":"IListNullableOps","description":"API documentation for IListNullableOps<A> extension from ribs_core","frontmatter":{"title":"IListNullableOps<A>","description":"API documentation for IListNullableOps<A> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/IListNullableOps.md","filePath":"api/package-ribs_core_ribs_core/IListNullableOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/IListNullableOps.md" };
const _hoisted_1 = {
  id: "nonulls",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="ilistnullableops-a" tabindex="-1">IListNullableOps&lt;A&gt; <a class="header-anchor" href="#ilistnullableops-a" aria-label="Permalink to &quot;IListNullableOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">IListNullableOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./IList" class="type-link">IList</a>&lt;<span class="type">A</span>?&gt;</code></pre></div><p>Operations avaiable when <a href="/ribs/api/package-ribs_core_ribs_core/IList.html">IList</a> elements are nullable.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("noNulls() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nonulls",
        "aria-label": 'Permalink to "noNulls() <Badge type="info" text="extension" /> {#nonulls}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IList" class="type-link">IList</a>&lt;<span class="type">A</span>&gt; <span class="fn">noNulls</span>()</code></pre></div><p>Returns a new list with all null elements removed.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/IList.html">IList&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/IListNullableOps.html">IListNullableOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noNulls</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> foldLeft</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nil</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (acc, elem) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> elem </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> null</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> acc </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> acc.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">appended</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(elem));</span></span></code></pre></div></details>', 4))
  ]);
}
const IListNullableOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  IListNullableOps as default
};
